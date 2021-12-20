module Stat
  class Rank < Base
    def title
      @player.active? ? ':hash:' : ':zzz:'
    end

    def value
      return 'Rank disabled (inactive)' unless @player.active?
      @player.current_rank
    end
  end
end