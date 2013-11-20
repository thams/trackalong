require ENV["RAILS_ENV_PATH"]
# TODO: gemify this as part of daemons gem
# Without setting the logger here, logging goes to the environment.log file, but doesn't get flushed
# until the application quits
# Via http://blog.trikeapps.com/2011/05/12/daemonize-rails-3-scripts.html
# Note: this doesn't log ActionController, ActionMailer, other rails loggers. See
# https://github.com/synth/Daemonator


logger = Trackalong::Application.config.logger
#Rails.logger = logger # Is this needed in addition to ActiveRecord::Base.logger?

#Rails.logger.auto_flushing = true

include NotifyAirbrake

logger.info("Daemon starting in environment: #{Rails.env}")

error_count = 0
last_error_time = Time.now

begin
  loop {
    logger.info "Looping. Last Trackpoint ID: #{Trackpoint.last.id if Trackpoint.last} "
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

