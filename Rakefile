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

task :set_inactive_players do
  Player.includes(:games).each { |p| p.set_inactive! if p.should_be_inactive? }
end

task :new_season do
  Task::NewSeason.new.process
end

task :update_players do
  Task::UpdatePlayersFromSlack.new.process
end

task :delete_game, [:game_id] do |task, args|
  id = args[:game_id]
  Task::DeleteGame.new.process(id)
end 