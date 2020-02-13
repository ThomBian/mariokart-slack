module Action
  class CreateGame
    include Concern::HasValues
    include Concern::HasPayload

    # TODO prevent creation of game without the right number of players
    MAX_PLAYERS = 4
    MIN_PLAYERS = 2

    BUTTON_ACTION_ID = 'show_score_modal'

    def initialize(params)
      @params = params
    end

    def process
      return Slack::Client.post_message(text: "A game is already ongoing!") if Game.draft.count > 0
      game = Game.create!({
                              created_by: created_by,
                              games_players_attributes: games_players_attributes
                          })

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
      @created_by ||= Player.find_by(username: payload['user']['id'])
    end

    def games_players_attributes
      player_usernames_from_input.map { |p_username| {player: Player.find_or_create_by(username: p_username)} }
    end

    def player_usernames_from_input
      values["players_input"]["players_value"]["selected_users"]
    end
  end
end
