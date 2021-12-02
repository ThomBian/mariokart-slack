module Dml
    class AssignSeason1
        def self.migrate
            s = Season.new(is_current: true)
            s.save
            Game.update_all season_id: s.id
        end
    end
end