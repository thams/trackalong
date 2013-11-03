require 'toadhopper'

# TODO: gemify this

# requires that toadhopper be configured with an airbrake_key, which happens in
# config/initializers/airbrake.rb

module NotifyAirbrake

  def notify_airbrake(ex)
    begin
      Airbrake.configure do |config|
        Toadhopper(config.api_key).post!(ex)
      end
      Rails.logger.error(ex.backtrace) # Do not put before Toadhopper call
    rescue Timeout::Error => timeout
      # sometimes Airbrake timesout. Best we can do is log it
      Rails.logger.error(ex.backtrace)
      Rails.logger.error(timeout.backtrace)
    end
  end

end
