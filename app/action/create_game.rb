module Action
  class CreateGame
    include Concern::HasPayloadParsing
    include Concern::HasApiParsing
    include Concern::OngoingBlocks
    include Concern::ServerResponse

    MAX_PLAYERS = 4
    MIN_PLAYERS = 2

    def initialize(players: [], params: nil)
      @players = players
      @params = params
    end

    def process
      return post_number_of_players_invalid_message unless number_of_players_valid?
      return post_game_ongoing_message if game_ongoing?

      game = Game.create!({created_by: created_by, games_players_attributes: games_players_attributes, season: Season.current})

      Slack::Client.post_message(blocks: ongoing_blocks(game))
      response_ok_basic
    end

    private

    def games_players_attributes
      @players.map {|player| {player: player, odd: odds(player, @players - [player]) }}
    end

    def odds(player, other_players)
      player.odds_to_win_against(other_players).round(2)
    end

    def created_by
      @created_by ||= Player.find_or_create_by(username: command_sent_by_user_id || user_id)
    end

    # validations
    def game_ongoing?
      Game.draft.count > 0
    end

    def number_of_players_valid?
      @players.length >= MIN_PLAYERS && @players.length <= MAX_PLAYERS
    end

    # post message
    def post_game_ongoing_message
      game = Game.draft.last
      Slack::Client.post_message(blocks: ongoing_blocks(game))
      response_ok_basic
    end

    def post_number_of_players_invalid_message
      Slack::Client.post_ephemeral_message(
          text: "A game has at least #{MIN_PLAYERS} players and at most #{MAX_PLAYERS} players",
          user: command_sent_by_user_id || user_id,
          channel_id: channel_id
      )
    end
  end
end
