require 'sinatra'
require 'pry'
require 'slack-ruby-client'
require 'json'

get '/' do
  'Hello world!'
end

post '/' do
  command = params[:text]
  puts "trying to parse your command #{command}"
  return unless params[:token] == ENV['SLACK_TOKEN']

  puts "token: #{ENV['SLACK_API_TOKEN']}"
  client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  client.auth_test
  if command == 'new'
    client.views_open(
      token: client.token,
      trigger_id: params[:trigger_id],
      view: {
        "type": "modal",
        "callback_id": "modal-with-inputs",
        "title": {
          "type": "plain_text",
          "text": "Modal with inputs"
        },
        "blocks": [
          {
            "type": "input",
            "block_id": "section_1",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "users_select",
              "action_id": "action_1"
            }
          },
          {
            "type": "input",
            "block_id": "section_11",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "plain_text_input",
              "action_id": "action_11"
            }
          },
          {
            "type": "input",
            "block_id": "section_2",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "users_select",
              "action_id": "action_2"
            }
          },
          {
            "type": "input",
            "block_id": "section_21",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "plain_text_input",
              "action_id": "action_21"
            }
          },
          {
            "type": "input",
            "block_id": "section_3",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "users_select",
              "action_id": "action_3"
            }
          },
          {
            "type": "input",
            "block_id": "section_31",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "plain_text_input",
              "action_id": "action_31"
            }
          },
          {
            "type": "input",
            "block_id": "section_4",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "users_select",
              "action_id": "action_4"
            }
          },
          {
            "type": "input",
            "block_id": "section_41",
            "label": {
              "type": "plain_text",
              "text": "Enter your value"
            },
            "element": {
              "type": "plain_text_input",
              "action_id": "action_41"
            }
          },
        ],
        "submit": {
          "type": "plain_text",
          "text": "Submit"
        }
      }
    )
  end
rescue Slack::Web::Api::Errors::SlackError => e
  puts e.response.body
end

post '/actions' do
  params['payload'] = JSON.parse(params['payload']).except('token').to_json
  values = JSON.parse(params['payload'])["view"]['state']
  puts values
  status :ok
end
