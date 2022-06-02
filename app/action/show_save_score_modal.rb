module Action
  class ShowSaveScoreModal
    include Concern::HasPayloadParsing
    include Concern::ServerResponse

    def initialize(params)
      @params = params
    end

    def process
      @client = Slack::Client.new
      response = @client.views_open(view_payload)

      ::Slack::Client.delete_message(ts: message_ts)
    end

    private

    def game
      @game ||= Game.find(block_action['value'])
    end

    def view_payload
      {
          token: @client.token,
          trigger_id: trigger_id,
          view: view_content
      }
    end

    def view_content
      {
          "type": "modal",
          "callback_id": ::Factory::ViewSubmission::SAVE_SCORE_CALLBACK_ID,
          "private_metadata": {game_id: game.id}.to_json.to_s,
          "notify_on_close": true,
          "title": {
              "type": "plain_text",
              "text": "Save the scores!",
              "emoji": true
          },
          "submit": {
              "type": "plain_text",
              "text": "Save!",
              "emoji": true
          },
          "close": {
              "type": "plain_text",
              "text": "Cancel",
              "emoji": true
          },
          blocks: inputs
      }
    end

    def inputs
      game.players.map do |p|
        {
            "type": "input",
            "block_id": p.username,
            "element": {
                "type": "plain_text_input",
                "action_id": "p_#{p.username}"
            },
            "label": {
                "type": "plain_text",
                "text": p.get_or_update_display_name,
                "emoji": true
            }
        }
      end
    end
  end
end
