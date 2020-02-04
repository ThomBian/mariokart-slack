module Stat
  class HighestElo < Base
    def title
      ':wowspin: Highest elo'
    end

    def value
      @player.highest_elo
    end
  end
end