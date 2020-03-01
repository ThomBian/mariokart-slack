module Stat
  class Rank < Base
    def title
      @player.active? ? ':hash:' : ':zzz:'
    end

    def value
      return 'Rank disabled (inactive)' unless @player.active?
      Player.with_rank.index_by(&:id)[@player.id].rank_value
    end
  end
end