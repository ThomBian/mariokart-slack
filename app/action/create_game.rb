module Action
  class CreateGame
    include ::Concern::HasPayloadParsing
    include ::Concern::HasApiParsing

    # TODO prevent creation of game without the right number of players
    MAX_PLAYERS = 4
    MIN_PLAYERS = 2

    BUTTON_ACTION_ID = 'show_score_modal'

    def initialize(params)
      @params = params
    end

    def process
      return post_number_of_players_invalid_message unless number_of_players_valid?
      return post_game_ongoing_message if game_ongoing?

      game = Game.create!({created_by: created_by, games_players_attributes: games_players_attributes})
      Slack::Client.post_message(blocks: blocks(game))
    end

    private

    # TODO add text: rank + elo + chance to win
    def blocks(game)
      [
          {
              "type": "actions",
              "elements": [{
                               "type": "button",
                               "text": {
                                   "type": "plain_text",
                                   "text": "Save score ✅",
                                   "emoji": true
                               },
                               "style": "primary",
                               "value": game.id.to_s,
                               "action_id": BUTTON_ACTION_ID
                           }]
          }
      ]
    end

    def created_by
      @created_by ||= Player.find_by(username: command_sent_by_user_id || user_id)
    end

    def games_players_attributes
      player_usernames_from_input.map { |p_username| {player: Player.find_or_create_by(username: p_username)} }
    end

    def number_of_players_valid?
      player_usernames_from_input.length >= MIN_PLAYERS && player_usernames_from_input.length <= MAX_PLAYERS
    end

    def game_ongoing?
      Game.draft.count > 0
    end

    def post_number_of_players_invalid_message
      Slack::Client.post_ephemeral_message(
          text: "A game has at least #{MIN_PLAYERS} players and at most #{MAX_PLAYERS} players",
          user: command_sent_by_user_id || user_id,
          channel_id: channel_id
      )
    end

    def post_game_ongoing_message
      Slack::Client.post_ephemeral_message(
          text: "A game is already ongoing!",
          user: command_sent_by_user_id || user_id,
          channel_id: channel_id
      )
    end

    def player_usernames_from_input
      values["players_input"]["players_value"]["selected_users"]
    end
  end
end
