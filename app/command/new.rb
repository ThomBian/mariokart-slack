module Command
  class New
    def initialize(params:)
      @params = params
    end

    def process
      raise 'Command new needs a trigger_id param' unless @params[:trigger_id]
      @client = Slack::Client.new
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
        "callback_id": "modal-with-inputs",
        "title": {
          "type": "plain_text",
          "text": "Modal with inputs"
        },
        "blocks": [
                  {
                    "type": "input",
                    "block_id": "player_1",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "users_select",
                      "action_id": "username_1"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "score_input_1",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "plain_text_input",
                      "action_id": "score_value_1"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "player_2",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "users_select",
                      "action_id": "username_2"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "score_input_2",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "plain_text_input",
                      "action_id": "score_input_value_2"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "player_3",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "users_select",
                      "action_id": "username_3"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "score_input_3",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "plain_text_input",
                      "action_id": "score_input_value_3"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "player_4",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "users_select",
                      "action_id": "username_4"
                    }
                  },
                  {
                    "type": "input",
                    "block_id": "score_input_4",
                    "label": {
                      "type": "plain_text",
                      "text": "Enter your value"
                    },
                    "element": {
                      "type": "plain_text_input",
                      "action_id": "score_input_value_4"
                    }
                  },
                ],
        "submit": {
          "type": "plain_text",
          "text": "Submit"
        }
      }
    end
  end
end
