module Dml
    class BacktrackElo
        def self.migrate
            Player.each do |p|
                gps = games_players.current_season.where('elo_diff IS NOT NULL').order('created_at DESC')
                
                current_elo = p.elo
                elos = gps.each do |gp|
                    gp.update elo: current_elo
                    current_elo -= gp.elo_diff
                end
            end
        end
    end
end