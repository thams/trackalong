source 'http://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "rspec"
gem 'nokogiri', '1.4.4'

# gem "passenger"

gem 'mysql2'

gem 'twitter'

#gem 'rail-settings', :git => 'git://github.com/ledermann/rails-settings.git'
#https://github.com/ledermann/rails-settings
gem 'ledermann-rails-settings', :require => 'rails-settings'

# Look up street addresses, IP addresses, and geographic coordinates, Perform geographic queries using objects
gem "geocoder" # git://github.com/alexreisner/geocoder.git or http://www.rubygeocoder.com/

# Parse KML files (and do other things)
gem "georuby", :git => "git://github.com/nofxx/georuby.git"

gem "airbrake"
gem "toadhopper"

group :development, :test do
  # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
  # gem 'ruby-debug'
  # gem 'ruby-debug19', :require => 'ruby-debug'

  #gem "debugger", :git => 'git://github.com/cldwalker/debugger.git' # (looks like this is now needed for debugging in 1.9.3)
  #gem "ruby-debug-ide"
  #gem "ruby-debug-base19x"

  # To get this to work, needed to download http://devnet.jetbrains.com/servlet/JiveServlet/download/5469361-16880/ruby-debug-base19x-0.11.30.pre10.gem.zip;jsessionid=3ED60C5AC785C545669D8B7F2469C848
  # http://devnet.jetbrains.com/message/5443846#5443846
  # and then gem install --local ~/Downloads/scratch/ruby-debug-base19x-0.11.30.pre10.gem
  gem 'ruby-debug-base19x', '>= 0.11.30.pre10'


  gem 'rspec-rails'

  # Really only needed for development and testing, allows you to generate
  # fixtures from actual data
  gem "db_fixtures_dump"

end

group :development do
end

group :test do

  gem "vcr" # , "2.2.2"
  gem "webmock"

  # Generates a test coverage report while running RSpec
  gem 'simplecov', :require => false # 0.6.4

end
