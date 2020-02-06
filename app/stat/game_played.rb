module Stat
  class GamePlayed < Base
    def title
      ':video_game: Number of games played: '
    end

    def value
      @player.games.count
    end
  end
end