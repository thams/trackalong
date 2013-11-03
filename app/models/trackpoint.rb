class Trackpoint < ActiveRecord::Base

  # Figure out which of these can go away!

  require 'net/http'
  require 'net/https'
  require "uri"

  require 'geo_ruby'
  require 'geo_ruby/simple_features'
  require 'geo_ruby/kml'

  include NotifyAirbrake

  # TODO: This is just a hack for working with example data. Should delete
  def self.start_up
    Dir["data/*.xml"].each do |filename|
      next unless File.file?(filename)
      Trackpoint.poll(File.read(filename))
    end
  end

  # assumes self.response is filed
  # sets up @doc so accessors can work
  def process
    # TODO: test case for Nokogiri::XML::SyntaxError
    return if self.response.blank?
    @doc = Nokogiri::XML(response) do |config|
      config.options = 0 # Nokogiri::XML::ParseOptions.STRICT
    end
    determine_terrain_elevation
  end

  def populate(some_xml)
    self.response = some_xml
    process
  end

  def self.show
    Trackpoint.all.each {|to| p "#{to.id} #{to.text_summary}" }
    nil
  end

  def self.poll(some_xml = nil)
    # TODO: needs test coverage using vcr

    unless some_xml
      delorme_api_url = Trackalong::Application.config.delorme_api_url # typically, https://explore.delorme.com/Feed/Share/#{USERNAME}
      # See https://support.delorme.com/kb/articles/26-about-inreach-kml-feeds
      # Also see API docs https://support.delorme.com/WebHelp/xmap7/delorme_help/z3_using_the_xmap_api_command_window/api_commands_and_parameters_x.htm
      # other data available in "https://explore.delorme.com/Feed/ShareLoader/#{USERNAME}"
      uri = URI.parse delorme_api_url
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      some_xml = response.body
      # TODO: pay attention to response.status and do something sensible if it isn't happy
      # response["header-here"] # All headers are lowercase
    end

    # TODO: this is not correct if items aren't loaded in order, or if tracking more than one user.
    last_observation = Trackpoint.last

    tracker_obs = Trackpoint.make(some_xml)

    if tracker_obs.kml_id == last_observation.try(:kml_id)
      # Don't save it if it isn't a new data point
      return tracker_obs
    end

    tracker_obs.save!

    tracker_obs.process_events

    return tracker_obs

  end

  def process_events
    if took_off?
      notify_about_takeoff
    elsif landed?
      notify_about_landing
    end

    if started_moving?
      notify_about_started_moving
    elsif stopped_moving?
      notify_about_stopped_moving
    end
  end

  def tweet_this(tweet_text)
    if Trackalong::Application.config.suppress_messaging
      logger.info "(SUPPRESSED) TWEETING: #{tweet_text}"
      return
    end
    logger.info "TWEETING: #{tweet_text}"
    # TODO: Store this response?
    begin
      # TODO: Handle messages longer than 140 characters
      Twitter.update tweet_text[0..139] if tweet_text
    rescue Twitter::Error => ex
      logger.info "Exception caught #{ex}"
      notify_airbrake(ex)
    end
  end


  def notify_about_takeoff
    msg = "Took off at #{Time.now.to_s} #{tweet_text_summary}"
    logger.info msg
    tweet_this msg
  end

  def notify_about_landing
    msg = "Landed at #{Time.now.to_s} #{tweet_text_summary}"
    logger.info msg
    tweet_this msg
  end

  # TODO: unit test
  def notify_about_started_moving
    msg = "Started moving at #{Time.now.to_s} #{tweet_text_summary}"
    logger.info msg
    tweet_this msg
  end

  # TODO: unit test
  def notify_about_stopped_moving
    msg = "Stopped moving at #{Time.now.to_s} #{tweet_text_summary}"
    logger.info msg
    tweet_this msg
  end

  # make but don't save a Trackpoint
  def self.make(some_xml)
    tracker_obs = Trackpoint.new
    tracker_obs.populate some_xml
    tracker_obs
  end

  def determine_terrain_elevation
    # Example data from google looks like this:
    #<ElevationResponse>
    #<status>OK</status>
    #<result>
    #<location>
    #<lat>37.1111111</lat>
    #<lng>-121.1111111</lng>
    #</location>
    #<elevation>3.8433254</elevation>
    #<resolution>76.3516159</resolution>
    #</result>
    #</ElevationResponse>
    gresponse = Net::HTTP::get_response("maps.googleapis.com", "/maps/api/elevation/xml?locations=#{latitude},#{longitude}&sensor=true")
    # TODO: handle case where result isn't HTTPOK
    if gresponse.class == Net::HTTPOK
      gdoc = Nokogiri::XML gresponse.body
      g_elevation_meters = gdoc.xpath("//elevation").text
      self.terrain_elevation = (g_elevation_meters.to_f * 3.28084).round.to_s
    else
      # TODO: needs unit test
      ex = RuntimeError.new("Couldn't get terrain elevation from Google #{gresponse}")
      notify_airbrake(ex)
    end
  end

  def text_summary(last_observation = nil)
    distance_info = "distance #{(distance(last_observation)).to_i} M" if last_observation
    "Aloft: #{aloft?} Moving: #{moving?} Fast: #{moving_fast?} Lat: #{latitude} Lon: #{longitude} Alt: #{altitude} Elev: #{terrain_elevation} #{altitude.to_f - terrain_elevation.to_f} #{event_type} #{kml_id} #{distance_info}"
  end

  def tweet_text_summary(last_observation = nil)
    "Lat: #{latitude} Lon: #{longitude} Alt: #{altitude} Elev: #{terrain_elevation}"
  end

  # @return altitude in feet
  def altitude
    @doc.present? || process
    meters = @doc.xpath("//xmlns:Data[@name='Altitude']/xmlns:value").text
    (meters.to_f * 3.28084).round.to_s
  end

  def longitude
    @doc.present? || process
    @doc.xpath("//xmlns:Data[@name='Longitude']/xmlns:value").text
  end

  def latitude
    @doc.present? || process
    @doc.xpath("//xmlns:Data[@name='Latitude']/xmlns:value").text
  end

  # @return ground velocity in knots
  def ground_velocity
    @doc.present? || process
    kmh = @doc.xpath("//xmlns:Data[@name='GroundVelocity']/xmlns:value").text
    knots = (kmh.to_i * 0.539957).round.to_s
  end

  def event_type
    @doc.present? || process
    # All elements called "Data" with an attribute called "name" whose value is "EventType", get their "value"
    @doc.xpath("//xmlns:Data[@name='EventType']/xmlns:value").text
  end

  def kml_id
    @doc.present? || process
    @doc.xpath("//xmlns:Data[@name='Id']/xmlns:value").text
  end

  def distance(a_tracker_obs)
    # TODO: make something more sensible if a_tracker_obs is nil
    return "n/a" unless a_tracker_obs
    gr = GeoRuby::SimpleFeatures::Geometry.from_kml(response)
    other = GeoRuby::SimpleFeatures::Geometry.from_kml(a_tracker_obs.response)
    line_string = GeoRuby::SimpleFeatures::LineString.from_points [other, gr]
    distance = line_string.spherical_distance
    # distance2 = last_point.spherical_distance(gr)
  end

  # @return true if recorded altitude AGL >= the argument
  def aloft?(an_altitude = 100.0)
    (altitude.to_f - terrain_elevation.to_f) >= an_altitude
  end

  def aground?(an_altitude = 100.0)
    !aloft?(an_altitude)
  end

  def moving?
    ground_velocity.to_f > 0.0
  end

  # @return true if recorded velocity >= the argument
  def moving_fast?(a_velocity = 50.0)
    ground_velocity.to_f > a_velocity
  end

  def landed?
    # Test for !moving is because ridge soaring would appear as landed.
    (!previous_observation || previous_observation.aloft?) && !aloft? && !moving?
  end

  def took_off?
    # TODO: How to handle if previous observation was ridge soaring?
    (!previous_observation || previous_observation.aground?) && aloft?
  end

  def started_moving?
    (!previous_observation || !(previous_observation.moving?)) && moving?
  end

  def stopped_moving?
    (!previous_observation || (previous_observation.moving?)) && !moving?
  end


  # TODO: uses prev database ID to determine which is last datapoint. Doesn't work for multi-user, and
  # doesn't work if you drop a data point (i.e., missing value in the sequence of primary keys)
  def previous_observation
    return nil unless self.id # This just here for spec test objects that haven't been saved.
    Trackpoint.find_by_id(self.id - 1)
  end

end
