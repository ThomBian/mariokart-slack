module Stat
  class LowestElo < Base
    def title
      ':clown_face: Lowest elo'
    end

    def value
      @player.lowest_elo
    end
  end
end