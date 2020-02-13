module Dml
  class SetGamesStatus
    def self.migrate
      Game.update_all("status = 'saved'")
    end
  end
end