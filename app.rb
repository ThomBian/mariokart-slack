require 'sinatra'

get '/' do
  'Hello world!'
end

post '/' do
  return unless params[:token] == ENV['SLACK_TOKEN']
  puts params
  'new command'
end
