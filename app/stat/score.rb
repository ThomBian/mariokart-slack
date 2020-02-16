module Stat
  module Score
    class Avg<Base
      def title
        ':eyes: Average score: '
      end

      def value
        avg
      end

      private

      def avg
        (played.sum(:score) / played.count.to_f).round(2)
      end

      def played
        @played ||= @player.games_players
      end
    end

    class Performances<Base

      def title
        ':muscle: '
      end

      def value
        emojis
      end

      private

      GROUP_BY_SCORE_EMOJI = "CASE WHEN score = 60 THEN ':star:' WHEN score >= 35 THEN ':ligue1:' WHEN score >= 30 THEN ':ligue2:' ELSE ':unacceptable:' END"

      def emojis
        @player.games_players.group(Arel.sql(GROUP_BY_SCORE_EMOJI)).count.to_a.map { |x| "#{x[0]} x#{x[1]}" }.join(' ')
      end
    end
  end
end