module Task
    class NewSeason
        def process
            # save_achievements -> adapt display of new game, save game, and rank to display achievement
            # reset score
            # post message
        end

        private

        def save_achievements
            # podium
            # most game played
            # most correct votes
        end

        def elo_podium
            Player.order(elo: :desc).limit(3)
        end

        def reset_score
            # reset score to all players to nil
        end

        def post_message
            # summary last season: number of game played, number of votes, time spent on mariokart
            # announce achievements
            # announce new season
        end
    end
end