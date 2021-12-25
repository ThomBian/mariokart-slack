module Concern
    module Extensions
        module Player::Stats
            def has_already_voted?(game)
                votes.where(game: game).any?
            end
        
            def current_rank
                return -1 unless active?
                ::Player.players_rank[id].rank_value
            end
        
            def elo_history
                gps = games_players.current_season.where('elo_diff IS NOT NULL').order('created_at DESC')
            
                elos = gps.pluck(:elo_diff).inject([elo]) do |memo, elo_diff|
                    previous_elo = memo[-1]
                    elo = previous_elo - elo_diff
                    memo << elo
                    memo
                end
        
                [Time.now, gps.pluck(:created_at)].flatten.map{|x| x.strftime("%Y-%m-%d %H:%M:%S")}.zip(elos).reverse()
            end
        
            def score_history
                games_players
                    .current_season.where('score IS NOT NULL')
                    .order('created_at')
                    .pluck(:created_at, :score)
                    .map {|current| [current[0].strftime("%Y-%m-%d %H:%M:%S"), current[1]]}
            end
        end
    end
end