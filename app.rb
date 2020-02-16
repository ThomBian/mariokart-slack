require_all 'app/stat'
require_all 'app/concern'
require_all 'app/lib'
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

    if ENV['UNDER_DEV'] == 'true'
      Slack::Client.post_message(text: ":robot_face: Someone is working on me! :robot_face:")
    else
      command = Factory::Command.new(params: params).build
      puts "Command received: #{command.class} with #{params}"
      command.process if command.present?
    end
    ''
  rescue Slack::Web::Api::Errors::SlackError => e
    puts e.response.body
  end


  post '/actions' do
    action = Factory::Action.new(params).build
    action.process
    ''
  rescue Slack::Web::Api::Errors::SlackError => e
    puts e.response.body
  end
end
