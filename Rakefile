require 'sinatra/activerecord/rake'
require_relative './config/environment'
require './app'

task :run do
  App.run!
end

task :console do
  require_all 'db/dml'
  Pry.start
end

desc 'This task send a message in the #mariokart-elo channel with the current ELO ranking'
task :display_rank_in_channel do
  Command::Rank.new.rank_of_the_day
end
