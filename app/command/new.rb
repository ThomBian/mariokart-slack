module Command
  class New
    MODAL_ID = 'score_view'
    MAX_PLAYERS = 4

    attr_reader :nb_players

    def initialize(command_params:, params:)
      @nb_players = sanitize(command_params)
      @params = params
    end

    def process
      raise 'Command new needs a trigger_id param' unless @params[:trigger_id]

      return post_alone_player_game if @nb_players == 1

      @client = Slack::Client.new(ENV['SLACK_API_TOKEN'])
      response = @client.views_open(view_payload)
      response['ok']
    end

    private

    def sanitize(command_params)
      return MAX_PLAYERS if command_params.blank?
      return MAX_PLAYERS unless command_params.kind_of?(Array) && command_params.length == 1

      number_of_players = command_params.first.to_i
      return MAX_PLAYERS unless number_of_players > 0 && number_of_players  <= 4
      number_of_players
    end

    def post_alone_player_game
      Slack::Client.post_direct_message(
        text: ':robot_face: Sneaky! You cannot save a game where you were the only human to play!',
        users: user_id
      )
    end

    def user_id
      @params['user_id']
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
        "callback_id": "score_view",
        "title": {
          "type": "plain_text",
          "text": "Save a new game!",
          "emoji": true
        },
        "blocks": inputs,
        "submit": {
          "type": "plain_text",
          "text": "Save!"
        }
      }
    end

    def inputs
      (1..@nb_players).flat_map {|i| player_score_inputs(i)}.flatten
    end

    def player_score_inputs(index)
      [{
        "type": "input",
        "block_id": "player_#{index}",
        "label": {
          "type": "plain_text",
          "text": ":mario_luigi_dance: Select a player:",
          "emoji": true
        },
        "element": {
          "type": "users_select",
          "action_id": "username_#{index}"
        }
      },
        {
          "type": "input",
          "block_id": "score_input_#{index}",
          "label": {
            "type": "plain_text",
            "text": ":point_right: Enter the number of points:",
            "emoji": true,
          },
          "element": {
            "type": "plain_text_input",
            "action_id": "score_value_#{index}"
          }
        }]
    end
  end
end
