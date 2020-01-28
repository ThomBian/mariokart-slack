class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)

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

  require File.join(root, '/config/initializers/autoloader.rb')
end
