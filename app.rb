require 'sinatra'
require 'pry'
require 'slack-ruby-client'

get '/' do
  'Hello world!'
end

post '/' do
  return unless params[:token] == ENV['SLACK_TOKEN']
  command = params[:text]
  puts "token: #{ENV['SLACK_API_TOKEN']}"
  client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  if command == 'new'
    client.views_open(token: client.token,
      trigger_id: params[:trigger_id],
      view: {
          "type": "modal",
          "callback_id": "new_game_modal",
          "title": {
            "type": "plain_text",
            "text": "Mariokart game",
            "emoji": true
          },
          "submit": {
            "type": "plain_text",
            "text": "Submit",
            "emoji": true
          },
          "close": {
            "type": "plain_text",
            "text": "Cancel",
            "emoji": true
          },
          "blocks": [
                    {
                      "type": "section",
                      "text": {
                        "type": "plain_text",
                        "text": "Entrer the result of the game",
                        "emoji": true
                      }
                    },
                    {
                      "type": "input",
                      "block_id": "first_player",
                      "element": {
                        "type": "plain_text_input"
                      },
                      "label": {
                        "type": "plain_text",
                        "text": "🥇",
                        "emoji": true
                      }
                    },
                    {
                      "type": "input",
                      "block_id": "second_player",
                      "element": {
                        "type": "plain_text_input"
                      },
                      "label": {
                        "type": "plain_text",
                        "text": "🥈",
                        "emoji": true
                      }
                    },
                    {
                      "type": "input",
                      "block_id": "third_player",
                      "element": {
                        "type": "plain_text_input"
                      },
                      "label": {
                        "type": "plain_text",
                        "text": "🥉",
                        "emoji": true
                      }
                    },
                    {
                      "type": "input",
                      "block_id": "fourth_player",
                      "element": {
                        "type": "plain_text_input"
                      },
                      "label": {
                        "type": "plain_text",
                        "text": "🇧🇪",
                        "emoji": true
                      }
                    }
                  ]

      }
    )
  end
rescue Slack::Web::Api::Errors::SlackError => e
  puts e.response.body
end

post '/actions' do
  puts params
end
