module Action
  class SaveScore
    include ::Concern::HasPayloadParsing
    include Lib::Elo
    include ::Concern::GameSummaryBlocks
    include ::Concern::ServerResponse

    def initialize(params)
      @params = params
    end

    def process
      ::Vote.transaction do
        save_new_elos!
        reactivate_players!
        save_game!
        save_money
        post_message
      end
      response_ok_basic
    end

    private

    def save_new_elos!
      game.players.each { |player| player.save_elo!(player.elo + new_elos_diff[player.id]) }
    end

    def game
      @game ||= Game.find(private_metadata["game_id"])
    end

    def new_elos_diff
      @new_elos_diff ||= new_elos_diff_player_id(game_results)
    end

    def game_results
      game.players.map { |player| {player: player, score: score_from_input(player.username)} }
    end

    def reactivate_players!
      game.players.inactive.each {|p| p.set_active!}
    end

    def save_game!
      game.update! status: :saved, games_players_attributes: games_players_attributes(new_elos_diff)
    end

    def games_players_attributes(new_elos_diff)
      game.games_players.includes(:player).map do |gp|
        player = gp.player
        {id: gp.id, score: score_from_input(player.username), elo_diff: new_elos_diff[player.id]}
      end
    end

    def score_from_input(username)
      values[username]["p_#{username}"]['value'].to_i
    end

    def save_money
      game.games_players.includes(:votes).winners.each {|gp| gp.votes.update_all correct: true }
      game.games_players.map(&:votes).flatten.each {|v| v.voted_by.update_money!(v) }
    end

    def post_message
      Slack::Client.post_message(blocks: summary_blocks(game))
    end
  end
end