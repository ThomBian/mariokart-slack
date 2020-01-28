module Concern
  module Elo

    def compute_from(game_results, player_elos)
      new_elos = []
      game_results.each do |result|
        player_username = result[:username]
        player_elo = player_elos[player_username].elo
        new_elo = player_elo

        game_results.each do |other_player_result|
          next if player_username == other_player_result[:username]

          other_player_elo = player_elos[other_player_result[:username]].elo
          outcome = game_outcome(result[:score], other_player_result[:score])
          new_elo += OneVsOne.new(player_elo, other_player_elo, outcome).compute_diff

          puts "#{player_username}(#{player_elo}) vs #{other_player_result[:username]}(#{other_player_elo}) [#{outcome}]-> #{new_elo}"
        end

        new_elos << { username: player_username, value: round(new_elo) }
      end
      new_elos
    end

    private

    def game_outcome(score_a, score_b)
      return :draw if score_a == score_b
      return :win if score_a > score_b
      :loose
    end

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
