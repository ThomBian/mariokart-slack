module Lib
  module Elo

    def new_elo(player_elo, one_ones)
      new_player_elo = player_elo
      one_ones.each do |one_one|
        new_player_elo += OneVsOne.new(player_elo, one_one.elo, one_one.outcome).compute_diff
      end
      new_player_elo
    end

    # @param game_results Array<Hash> each hash should have a :player => the player who played and a :score the number
    #   of points during the game
    # def new_elos_diff_player_id(game_results)
    #   game_results.inject({}) do |res, game_result|

    #     player = game_result[:player]
    #     diff = 0
    #     game_results.each do |other_game_result|
    #       next if player.id == other_game_result[:player].id

    #       outcome = game_outcome(game_result[:score], other_game_result[:score])
    #       diff += OneVsOne.new(player.elo, other_game_result[:player].elo, outcome).compute_diff
    #     end

    #     res[player.id] = round(diff)
    #     res
    #   end
    # end

    def game_outcome(score_a, score_b)
      return :draw if score_a == score_b
      return :win if score_a > score_b
      :loose
    end

    private

    def round(f)
      f.round(2)
    end

    class OneVsOne
      DELTA = 30

      # @param elo_a [float]
      # @param elo_b [float]
      # @param game_outcome[:win, :loose, nil], send nil if case of draw
      def initialize(elo_a, elo_b, game_outcome)
        @elo_a = elo_a
        @elo_b = elo_b
        @game_outcome = game_outcome
      end

      # @return [Float] the elo diff to add or remove to player A for winning / losing / drawing against player B
      def compute_diff
        proba_a_win = chance_to_win(@elo_b, @elo_a)
        case @game_outcome
        when :win
          round(DELTA * (1 - proba_a_win))
        when :loose
          round(DELTA * (0 - proba_a_win))
        else
          round(DELTA * (0.5 - proba_a_win))
        end
      end

      private

      def chance_to_win(elo_a, elo_b)
        round((1 / (1 + 10.pow(((elo_a - elo_b) / 400.0)))))
      end

      def round(f)
        f.round(2)
      end
    end
  end
end
