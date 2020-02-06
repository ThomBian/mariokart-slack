module Stat
  module Elo
    class Current < Base
      def title
        ':fleur_de_lis:'
      end

      def value
        @player.elo
      end
    end

    class Highest < Base
      def title
        ':wowspin: Highest elo: '
      end

      def value
        @player.highest_elo
      end
    end

    class Lowest < Base
      def title
        ':clown_face: Lowest elo: '
      end

      def value
        @player.lowest_elo
      end
    end
  end
end