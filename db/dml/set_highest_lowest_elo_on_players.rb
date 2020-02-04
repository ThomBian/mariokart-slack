module Dml
  class SetHighestLowestEloOnPlayers
    def self.migrate
      Player.update_all('highest_elo = elo')
      Player.update_all('lowest_elo = elo')
    end
  end
end