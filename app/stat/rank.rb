module Stat
  class Rank < Base
    def title
      ':fleur_de_lis: Rank'
    end

    def value
      Player.with_rank.index_by(&:id)[@player.id].rank_value
    end
  end
end