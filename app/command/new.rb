module Command
  class New
    include ::Concern::HasApiParsing

    attr_reader :nb_players

    def initialize(params:)
      @params = params
    end

    def process
      return post_game_ongoing_message if game_ongoing?
      raise 'Command new needs a trigger_id param' unless @params[:trigger_id]

      @client = Slack::Client.new(ENV['SLACK_API_TOKEN'])
      response = @client.views_open(view_payload)
      response['ok']
    end

    private

    def game_ongoing?
      Game.draft.count > 0
    end

    def post_game_ongoing_message
      Slack::Client.post_ephemeral_message(
          text: "A game is already ongoing!",
          user: user_id,
          channel_id: channel_id
      )
    end

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
        callback_id: ::Factory::ViewSubmission::NEW_CALLBACK_ID,
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
