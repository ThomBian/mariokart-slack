module Dml
    class AssignMoney
        def self.migrate
            Player.update_all money: 50
        end
    end
end