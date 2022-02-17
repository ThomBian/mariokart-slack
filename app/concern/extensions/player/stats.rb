module Concern
    module Extensions
        module Player::Stats
            include Lib::Elo

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

            def games_played
                played.count
            end
    
            def last_elo_diff
                return -1 unless played.last.present?
                played.last.elo_diff
            end
    
            def avg_score
                return -1 unless played.count > 0
                (played.sum(:score) / played.count.to_f).round(2)
            end

            def game_outcomes_against(other_player, limit = 5)
                games_in_common = Game.saved.where(id: GamesPlayers.where(player_id: [id, other_player.id]).
                    group(:game_id).
                    having("count(*) >= 2").
                    select(:game_id))
                games_in_common.order(created_at: :desc).limit(limit).map do |game|
                    my_score = GamesPlayers.find_by(player_id: id).score
                    other_score = GamesPlayers.find_by(player: other_player).score
                    game_outcome(my_score, other_score)
                end
            end

            # @see https://www.aceodds.com/bet-calculator/odds-converter.html
            def odds_to_win_against(players)
                1 / chance_to_win_against(players)
            end

            # @see https://stats.stackexchange.com/a/66398
            # @see "https://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details"
            def chance_to_win_against(players)
                qs = [self, players].flatten.map {|p| 10.pow(p.private_elo/400.0)}
                qs[0].to_f / qs.flatten.sum
            end

            private 

            def played
                @played ||= games_players.joins(:game).where(game: {status: :saved})
            end
        end
    end
end