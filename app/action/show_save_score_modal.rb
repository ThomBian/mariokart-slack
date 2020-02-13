# TODO
#   - create an input to associate input <> user <> score
#   - find a way to use the game id to easily retrieve it later on
module Action
  class ShowSaveScoreModal
    include Concern::HasBlockAction

    CALLBACK_ID = 'save_score_submission'

    def initialize(params)
      @params = params
    end

    def process
      @client = Slack::Client.new(ENV['SLACK_API_TOKEN'])
      response = @client.views_open(view_payload)
      raise response unless response['ok']

      ::Slack::Client.delete_message(ts: message_ts)
    end

    private

    def game
      @game ||= Game.find(block_action['value'])
    end

    def message_ts
      payload['message']['ts']
    end

    def view_payload
      {
          token: @client.token,
          trigger_id: payload['trigger_id'],
          view: view_content
      }
    end

    def view_content
      {
          "type": "modal",
          "callback_id": CALLBACK_ID,
          "private_metadata": game.id.to_s,
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
                "text": p.slack_username,
                "emoji": true
            }
        }
      end
    end
  end
end