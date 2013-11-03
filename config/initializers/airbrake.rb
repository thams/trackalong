# TODO: gemify this along with the notify_airbrake gem??
Airbrake.configure do |config|
  config.api_key = YAML::load(File.open("#{Rails.root}/config/api_keys.yml"))[Rails.env]["airbrake_key"]
  config.development_environments = ["production", "development", "test"] # Or leave empty for all envs
end
