require 'sinatra'
require 'slack-ruby-client'

get '/' do
  'Hello world!'
end

post '/' do
  return unless params[:token] == ENV['SLACK_TOKEN']
  command = params[:text]
  puts "token: #{ENV['SLACK_API_TOKEN']}"
  client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  data = client.auth_test
  puts data
  if command == 'new'
    client.dialog_open(token: client.token,
      trigger_id: 'TOCHANGE',
      dialog: {
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
          }]
      }
    )
  end
end
