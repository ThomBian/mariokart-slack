module Lib
  module Elo

    def elo_diff(player_elo, one_ones)
      diff = 0
      one_ones.each do |one_one|
        diff += OneVsOne.new(player_elo, one_one[:elo], one_one[:outcome]).compute_diff
      end
      diff
    end

    def game_outcome(score_a, score_b)
      return :unknown unless score_a.present? && score_b.present?
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
