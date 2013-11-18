require ENV["RAILS_ENV_PATH"]
# TODO: gemify this as part of daemons gem
# Without setting the logger here, logging goes to the environment.log file, but doesn't get flushed
# until the application quits
# Via http://blog.trikeapps.com/2011/05/12/daemonize-rails-3-scripts.html
# Note: this doesn't log ActionController, ActionMailer, other rails loggers. See
# https://github.com/synth/Daemonator
logger = ActiveSupport::BufferedLogger.new(
  File.join(Rails.root, "log", "trackalong_daemon.log"),Logger::INFO)
Rails.logger = logger
ActiveRecord::Base.logger = logger

#Rails.logger.auto_flushing = true

include NotifyAirbrake

# TODO: logger instead of print
p "Environment: #{Rails.env}"

error_count = 0
last_error_time = Time.now

begin
  loop {
    # TODO: logger instead of print
    p "#{Time.now} #{Trackpoint.last.id if Trackpoint.last} "
    Trackpoint.poll
    sleep 60
  }
rescue  => e
  error_count = error_count + 1
  last_error_time = Time.now
  notify_airbrake(e)
  if error_count < 10 || last_error_time < 12.minutes.ago
    if last_error_time < 12.minutes.ago
      error_count = 0
    end
    sleep 60 # Need this or the retries just fire off a flood. # TODO Unit test
    retry
  end
  notify_airbrake(Exception.new("Trackalong daemon gave up with error_count = #{error_count}"))
end

