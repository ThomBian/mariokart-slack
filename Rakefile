require 'sinatra/activerecord/rake'
require_relative './config/environment'
require './app'

task :run do
  App.run!
end

task :console do
  Pry.start
end
