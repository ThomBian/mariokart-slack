class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  use Rack::JSONBodyParser
  
  set :root,  File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, 'app', 'views') }
  set :public_folder, 'public'

  include ::Concern::ServerResponse

  get ['/', '/games', '/ranking', '/add-money'] do
    @entry_point = File.join('js', 'index.js')
    erb :template
  end

  get '/player/:id' do
    @entry_point = File.join('/js', 'index.js')
    puts @entry_point
    erb :template
  end

  post '/data' do
    query_string = params[:query]
    variables = params[:variables]
    result = GraphQl::AppSchema.execute(query_string, variables: variables)
    response_ok_with_body(result)
  end

  # Slack 
  post '/' do
    return unless params[:token] == ENV['SLACK_TOKEN']

    if ENV['UNDER_DEV'] == 'true'
      Slack::Client.post_message(text: ":robot_face: Someone is working on me! :robot_face:")
    else
      command = Factory::Command.new(params: params).build
      puts "Command received: #{command.class} with #{params}"
      command.process if command.present?
    end
    response_ok_basic
  rescue Slack::Web::Api::Errors::SlackError => e
    puts e.response.body
  end


  post '/actions' do
    action = Factory::Action.new(params).build
    action.process
  rescue Slack::Web::Api::Errors::SlackError => e
    puts e.response.body
  end
end
