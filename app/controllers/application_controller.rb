class ApplicationController < ActionController::Base
  protect_from_forgery
  # TODO: Could do this instead of AirBrake
  # include ExceptionNotifiable
end
