module Action
  class SaveScore
    include ::Concern::HasPayloadParsing
    include Lib::Elo
    include ::Concern::GameSummaryBlocks

    def initialize(params)
      @params = params
    end

    def process
      new_elos_diff_player_id = new_elos_diff_player_id(game_results)
      save_new_elos!(new_elos_diff_player_id)
      reactivate_players!
      game.update! status: :saved, games_players_attributes: games_players_attributes(new_elos_diff_player_id)
      game.games_players.includes(:votes).winners.each {|gp| gp.votes.update_all correct: true }

      Slack::Client.post_message(blocks: summary_blocks(game))
    end

    private

    def game
      @game ||= Game.find(private_metadata)
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

    def save_new_elos!(new_elos_diff)
      game.players.each { |player| player.save_elo!(player.elo + new_elos_diff[player.id]) }
    end

    def reactivate_players!
      game.players.inactive.each {|p| p.set_active!}
    end

    def game_results
      game.players.map { |player| {player: player, score: score_from_input(player.username)} }
    end
  end
end