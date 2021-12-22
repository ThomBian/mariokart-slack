ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

if ENV['RACK_ENV'] == 'development'
  ActiveRecord::Base.logger = Logger.new(STDOUT)

  require 'dotenv'
  Dotenv.load
end

require 'rack'
require 'rack/contrib'

require 'sinatra'

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir("app/")
loader.push_dir("app/model")
loader.setup