require 'spec_helper'

describe Trackpoint do

  #it "should summarize" do
  #  # this is not a test, just used for debugging previously-grabbed data
  #
  #  last_obs = nil
  #  #points = YAML.load_file("scratch_data/tracker_observations.yml")
  #  points = YAML.load_stream(File.open("scratch_data/tracker_observations.yml"))
  #  points.each do |point|
  #    r = Trackpoint.create(point.first[1])
  #    p r.text_summary(last_obs)
  #    last_obs = r
  #  end
  #end

  #it "run it through paces" do
  #  (90..113).each do |index|
  #    kml = File.read("spec/data/#{index}.kml")
  #    to = Trackpoint.poll(kml)
  #    p "#{index}: #{to.text_summary}"
  #  end
  #end

  it "should know timestamp from the trackpoint data" do
    f = File.read "spec/data/landing_1.xml"
    tox = Trackpoint.make(f)
    tox.event_time_stamp.should == DateTime.new(2013, 10, 20, 16, 15, 15)# DateTime.strptime("10/20/2013 4:15:15 PM", '%m/%d/%Y %I:%M:%S %p')
  end

  it "should poll" do
    VCR.use_cassette('synopsis', :record => :none) do # options :record [:all, :none, :new_episodes, :once]
      to = Trackpoint.poll
      to.should be_moving
    end
  end

  it "should do something sensible to find previous Observation"

  it "should figure if I'm going fast" do
    f = File.read "spec/data/2013-09-05-c16-24-26.xml"
    tox = Trackpoint.make(f)
    tox.ground_velocity.should == 33.5313297
    tox.response.should_not be_nil
    tox.should_not be_moving_fast
  end

  it "should figure out I'm aloft" do
    f = File.read "spec/data/landing_1.xml"
    tox = Trackpoint.make(f)
    tox.response.should_not be_nil
    tox.should be_aloft
  end


  it "should figure I'm stopped" do
    f = File.read "spec/data/landing_2.xml"
    tox = Trackpoint.make(f)
    tox.response.should_not be_nil
    tox.should_not be_moving
  end


  it "should only consider landed if previously aloft and then stopped" do
    # moving on the ground not landed. User is driving a car.
    f1 = File.read "spec/data/landing_1.xml"
    tox1 = Trackpoint.make(f1)
    tox1.save!
    tox1.should be_aloft

    f2 = File.read "spec/data/landing_2.xml"
    tox2 = Trackpoint.make(f2)
    tox2.save!

    tox2.should be_landed
  end

  it "don't do took_off on every aloft message, just the first one" do
    a = Trackpoint.new
    a.stub(:aloft?).and_return true
    b = Trackpoint.new
    b.stub(:aloft?).and_return true
    b.stub(:previous_observation).and_return a
    b.should_not be_landed
    b.should_not be_took_off
  end

  it "don't do landed on every aground message, just the first one" do
    a = Trackpoint.new
    a.stub(:aloft?).and_return false
    b = Trackpoint.new
    b.stub(:aloft?).and_return false
    b.stub(:previous_observation).and_return a
    b.should_not be_landed
    b.should_not be_took_off
  end

  it "should recognize when I take off" do
    a = Trackpoint.new
    a.stub(:aloft?).and_return false
    b = Trackpoint.new
    b.stub(:aloft?).and_return true
    b.stub(:previous_observation).and_return a
    b.should_not be_landed
    b.should be_took_off
  end

  it "should notify when I take off" do
    f = File.read "spec/data/landing_1.xml" # needs the fields for the tweet description.
    b = Trackpoint.make(f)
    b.should_receive :notify_about_takeoff

    b.stub(:took_off?).and_return true
    b.process
    b.process_events
  end

  it "should use feet and knots" do
    f = File.read "spec/data/landing_1.xml"
    b = Trackpoint.make(f)
    b.ground_velocity.should == 74.5680617
    b.altitude.should == 4500.3938448
    b.terrain_elevation.should == 2305
  end
  end

  it "should tweet altitudes and elevations in feet, not meters" do
    f = File.read "spec/data/landing_1.xml" # needs the fields for the tweet description.
    b = Trackpoint.make(f)
    b.should_receive(:tweet_this).with(/Alt: 4500 Elev: 2305/).twice # twice: one for takeoff and one for moving
    b.stub(:took_off?).and_return true
    b.process
    b.process_events
  end

  it "should notify when I go from aloft to landed"

  it "Feature: when departing or landing, say where (nearest airport, city, etc)"

end
