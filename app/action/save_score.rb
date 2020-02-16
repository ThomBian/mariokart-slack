module Action
  class SaveScore
    include ::Concern::HasPayloadParsing
    include Lib::Elo
    include ::Concern::GameSummaryBlocks

    def initialize(params)
      @params = params
    end

    def process
      save_new_elos(new_elos(game_results))
      game.update! status: :saved, games_players_attributes: games_players_attributes

      Slack::Client.post_message(blocks: summary_blocks(game))
    end

    private

    def game
      @game ||= Game.find(private_metadata)
    end

    def games_players_attributes
      game.games_players.includes(:player).map do |gp|
        {id: gp.id, score: score_from_input(gp.player.username)}
      end
    end

    def score_from_input(username)
      values[username]["p_#{username}"]['value'].to_i
    end

    def save_new_elos(new_elos)
      new_elos.each { |player, new_elo| player.save_elo!(new_elo) }
    end

    def game_results
      game.players.map { |player| {player: player, score: score_from_input(player.username)} }
    end
  end
end