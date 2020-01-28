require 'dotenv'
Dotenv.load

require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV', 'development'))
if ENV['development']
  require 'pry'
end