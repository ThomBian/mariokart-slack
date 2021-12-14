require 'dotenv'
Dotenv.load

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'] || 'development')

if ENV['RACK_ENV'] == 'development'
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

require 'rack'
require 'rack/contrib'

require 'sinatra'

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir("app/")
loader.push_dir("app/model")
loader.setup