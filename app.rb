require 'sinatra'
require 'pry'
require 'slack-ruby-client'
require 'json'

require_relative 'command/factory'
require_relative 'slack/client'

get '/' do
  'Hello world!'
end

post '/' do
  return unless params[:token] == ENV['SLACK_TOKEN']

  command = Command::Factory.new(params: params).build
  command.process if command.present?

  ''
rescue Slack::Web::Api::Errors::SlackError => e
  puts e.response.body
end

post '/actions' do
  params['payload'] = JSON.parse(params['payload']).except('token').to_json
  values = JSON.parse(params['payload'])["view"]['state']['values']
  puts values
  ''
end
