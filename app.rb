class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  use Rack::JSONBodyParser
  
  set :root,  File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, 'app', 'views') }
  set :public_folder, 'public'

  set :session_secret, ENV['SESSION_SECRET']
  enable :sessions

  include ::Concern::ServerResponse

  get ['/', '/games', '/ranking', '/add-money', '/me'] do
    @entry_point = File.join('js', 'index.js')
    erb :template
  end

  get '/player/:id' do
    @entry_point = File.join('/js', 'index.js')
    erb :template
  end

  post '/data' do
    load_current_user

    query = params[:query]
    variables = params[:variables]
    operation_name = params[:operationName]
    context = {current_user: @current_user}
    result = GraphQl::AppSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

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

  get '/login' do
    open_id = Lib::OpenId.new('https://slack.com', ENV['SLACK_CLIENT_ID'], ENV['LOGIN_REDIRECT_URL'])
    nonce = SecureRandom.base64
    session[:nonce] = nonce
    
    redirect_link = open_id.auth_uri(nonce)
    redirect redirect_link
  end

  get '/connect' do
    code = params[:code]
    nonce = session[:nonce]
    open_id = Lib::OpenId.new('https://slack.com', ENV['SLACK_CLIENT_ID'], ENV['LOGIN_REDIRECT_URL'])
    user_info = open_id.redirect(code, nonce)

    @current_user = User.find_by(email: user_info.email)
    @current_user = User.create(email: user_info.email, name: user_info.name) unless @current_user.present?

    @current_user.player = Player.find_by(real_name: @current_user.name)

    session[:user_id] = @current_user.id
    redirect '/'
  end

  private 

  def load_current_user
    user_id = session[:user_id]
    @current_user = user_id.present? ? User.find(user_id) : nil
  end
end
