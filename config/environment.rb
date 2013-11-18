# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trackalong::Application.initialize!

# https://gist.github.com/rickyah/1999991#file-rails-add-timestamps-to-logs
# Adds timestamps to logs
# put it at the end of environment.rb
module ActiveSupport
  class BufferedLogger
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s

      level = {
        0 => "DEBUG",
        1 => "INFO",
        2 => "WARN",
        3 => "ERROR",
        4 => "FATAL"
      }[severity] || "U"

      message = "[%s: %s] %s" % [level, Time.now.strftime("%m%d %H:%M:%S"), message]

      message = "#{message}\n" unless message[-1] == ?\n
      buffer << message
      auto_flush
      message
    end
  end
end