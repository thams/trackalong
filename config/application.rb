require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

class TimeStampedLogger < ActiveSupport::BufferedLogger
  def add(severity, message = nil, progname = nil, &block)
  # also see ideas here:
  # https://gist.github.com/rickyah/1999991#file-rails-add-timestamps-to-logs

          level = {
            0 => "DEBUG",
            1 => "INFO",
            2 => "WARN",
            3 => "ERROR",
            4 => "FATAL"
          }[severity] || "U"

    now = Time.now
    message = "[%5s %s] %s" % [level,
                               now.strftime("%m-%d %H:%M:%S") + (".%03d" % (now.to_f*1000.to_i%1000)),     #use "%m-%d %H:%M:%S.%3N" in rails 1.9
                               message]

    message = "#{message}" unless message[-1] == ?\n
    super(severity, message, progname, &block)
  end
end


module Trackalong
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
      # g.orm              :mongoid
      g.template_engine  :haml
      g.test_framework   :rspec
    end

    keys_hash = YAML::load(File.open("#{Rails.root}/config/api_keys.yml"))

    Twitter.configure do |twitter_config|
      twitter_config.consumer_key = keys_hash[Rails.env]["twitter_consumer_key"]
      twitter_config.consumer_secret = keys_hash[Rails.env]["twitter_consumer_secret"]
      twitter_config.oauth_token = keys_hash[Rails.env]["twitter_oauth_token"]
      twitter_config.oauth_token_secret = keys_hash[Rails.env]["twitter_oauth_token_secret"]
    end

    config.wunderground_api_key = keys_hash[Rails.env]["wunderground_key"]

    config.delorme_api_url = keys_hash[Rails.env]["delorme_api_url"]

    # Load the top-level lib contents
    # x = Dir["#{config.root}/lib", "#{config.root}/lib/**/"] # if you want subdirs
    x = Dir["#{config.root}/lib"]
    config.autoload_paths += x

    config.log_level = :info
    config.logger = TimeStampedLogger.new(config.paths["log"].first)
    config.logger.level = TimeStampedLogger.const_get(config.log_level.to_s.upcase)
    ActiveRecord::Base.logger = config.logger


  end
end
