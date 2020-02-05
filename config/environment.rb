require 'dotenv'
Dotenv.load

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])