require 'dotenv'
Dotenv.load

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

if ENV['RACK_ENV'] == 'development'
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
