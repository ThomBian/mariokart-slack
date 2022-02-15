module Dml
    class BacktrackPrivateElo
        def self.migrate
            Player.all.each do |p|
                p.update private_elo: p.elo
            end
        end
    end
end