module Task
    class NewSeason
        def process
            save_achievements # -> adapt display of new game, save game, and rank to display achievement
            reset_score
            # post message
        end

        private

        def save_achievements
            # podium
            @elo_top_five[1].achievements << Achievement.find_by(name: '1st place')
            @elo_top_five[3].achievements << Achievement.find_by(name: '3rd place')
            @elo_top_five[2].achievements << Achievement.find_by(name: '2nd place')
            
            # most game played
            most_game_achievement = Achievement.find_by(name: 'Most games')
            most_games_played.each {|p|  p.achievements << most_game_achievement}

            # most correct votes
            most_correct_votes_achievement = Achievement.find_by(name: 'Most correct votes')
            most_correct_votes.each {|p|  p.achievements << most_correct_votes_achievement}
        end

        def elo_top_five
            @elo_top_five ||= Player.order(elo: :desc).limit(5)
        end

        def most_games_played
            return [] if GamesPlayers.count <= 0

            games_per_players = GamesPlayers.group(:player_id).count
            max_game = games_per_players.values.max
            player_ids = games_per_players.select {|k, v| v == max_game }.keys
            Player.where(id: player_ids)
        end

        def most_correct_votes
            correct_votes = Vote.winners
            return [] if correct_votes.count <= 0

            correct_votes_per_players = correct_votes.group(:voted_by).count
            max_correct_votes = correct_votes_per_players.values.max
            player_ids = correct_votes_per_players.select {|k, v| v == max_correct_votes }.keys
            Player.where(id: player_ids)
        end

        def reset_score
            Player.update_all(elo: 1000)
        end

        def post_message
            # summary last season: number of game played, number of votes, time spent on mariokart
            # announce achievements
            # announce new season
        end
    end
end