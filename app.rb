require_all 'app/concern'
require_all 'app/serializer'
require_all 'app/slack'
require_all 'app/factory'
require_all 'app/model'
require_all 'app/command'
require_all 'app/action'

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

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
end
