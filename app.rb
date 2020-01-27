require 'sinatra'
require 'pry'
require 'slack-ruby-client'
require 'json'
require 'require_all'

require_all 'app/concern'
require_all 'app/serializer'
require_all 'app'

get '/' do
  'Hello world!'
end

post '/' do
  return unless params[:token] == ENV['SLACK_TOKEN']

  command = Factory::Command.new(params: params).build
  command.process if command.present?

  ''
rescue Slack::Web::Api::Errors::SlackError => e
  puts e.response.body
end


post '/actions' do
  action = Factory::Action.new(params).build
  action.process
  ''
end
