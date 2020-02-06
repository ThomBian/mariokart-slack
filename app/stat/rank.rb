module Stat
  class Rank < Base
    def title
      ':hash:'
    end

    def value
      Player.with_rank.index_by(&:id)[@player.id].rank_value
    end
  end
end