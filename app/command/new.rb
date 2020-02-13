# TODO:
#   - prevent someone to create a game while there is a draft game at the moment
module Command
  class New
    CALLBACK_ID = 'create_game'

    attr_reader :nb_players

    def initialize(params:)
      @params = params
    end

    def process
      raise 'Command new needs a trigger_id param' unless @params[:trigger_id]

      @client = Slack::Client.new(ENV['SLACK_API_TOKEN'])
      response = @client.views_open(view_payload)
      response['ok']
    end

    private

    def view_payload
      {
        token: @client.token,
        trigger_id: @params[:trigger_id],
        view: view_content
      }
    end

    def view_content
      {
        "type": "modal",
        callback_id: CALLBACK_ID,
        "title": {
          "type": "plain_text",
          "text": "Start a game!",
          "emoji": true
        },
        "submit": {
          "type": "plain_text",
          "text": "Go!",
          "emoji": true
        },
        "close": {
          "type": "plain_text",
          "text": "Cancel",
          "emoji": true
        },
        "blocks": [{
          "type": "input",
          "block_id": "players_input",
          "element": {
            "type": "multi_users_select",
            "action_id": "players_value",
            "placeholder": {
              "type": "plain_text",
              "emoji": true,
              "text": "Select players"
            }
          },
          "label": {
            "type": "plain_text",
            "text": "Players of the current game:",
            "emoji": true
          }
        }]
      }
    end
  end
end
