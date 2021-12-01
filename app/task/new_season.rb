module Task
    class NewSeason
        def process
            reset_achievements
            save_achievements
            reset_score
            post_message
        end

        private

        def reset_achievements
            PlayersAchievements.destroy_all
        end

        def save_achievements
            # podium
            # handle same rank
            elo_top_five[0].achievements << Achievement.find_by(name: '1st place')
            elo_top_five[1].achievements << Achievement.find_by(name: '2nd place')
            elo_top_five[2].achievements << Achievement.find_by(name: '3rd place')
            
            # Todo: later

            # most game played
            # most_game_achievement = Achievement.find_by(name: 'Most games')
            # most_games_played_players.each {|p|  p.achievements << most_game_achievement}

            # most correct votes
            # most_correct_votes_achievement = Achievement.find_by(name: 'Most correct votes')
            # most_correct_votes_players.each {|p|  p.achievements << most_correct_votes_achievement}
        end

        def elo_top_five
            @elo_top_five ||= Player.with_rank.ordered_by_elo.select {|p| p.rank_value <= 5}
        end

        # Todo: later

        # def most_games_played_players
        #     return @players_with_most_game if @players_with_most_game.defined?
        #     @players_with_most_game = [] if GamesPlayers.count <= 0

        #     players_ids = games_per_players.select {|k, v| v == max_game }.keys
        #     @players_with_most_game = Player.where(id: player_ids)
        #     @players_with_most_game
        # end

        # def games_per_players
        #     @games_per_players ||= GamesPlayers.group(:player_id).count
        # end

        # def max_game_played
        #     @max_game ||= games_per_players.values.max
        # end

        # def most_correct_votes_players
        #     return @most_correct_votes_players if @most_correct_votes_players.deifned?
        #     @most_correct_votes_players = [] if correct_votes_per_player.empty?

        #     player_ids = correct_votes_per_players.select {|k, v| v == max_correct_votes }.keys
        #     @most_correct_votes_players = Player.where(id: player_ids)
        #     @most_correct_votes_players
        # end

        # def correct_votes_per_player
        #     @correct_votes_per_player ||= Vote.winners.group(:voted_by).count
        # end

        # def max_correct_votes
        #     @max_correct_votes ||= correct_votes_per_players.values.max
        # end

        def reset_score
            Player.update_all(elo: 1000)
        end

        def post_message
            Slack::Client.post_message(blocks: blocks)
        end

        def blocks
            [
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": "SEASON IS OVER!",
                        "emoji": true
                    }
                },
                {
                    "type": "context",
                    "elements": [
                        {
                            "type": "mrkdwn",
                            "text": "Time to celebrate the winners and to start over for the other ones..."
                        }
                    ]
                },
                # {
                #     "type": "section",
                #     "text": {
                #         "type": "mrkdwn",
                #         "text": season_summary_text
                #     }
                # },
                {
                    "type": "divider"
                },
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": ":trophy: Podium of the season",
                        "emoji": true
                    }
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": podium_text
                    }
                },
                {
                    "type": "divider"
                },
                # {
                #     "type": "header",
                #     "text": {
                #         "type": "plain_text",
                #         "text": ":eyes: Other awards",
                #         "emoji": true
                #     }
                # },
                # {
                #     "type": "section",
                #     "text": {
                #         "type": "mrkdwn",
                #         "text": other_awards_text
                #     }
                # },
                # {
                #     "type": "divider"
                # },
                {
                    "type": "context",
                    "elements": [
                        {
                            "type": "mrkdwn",
                            "text": "All players' elo has been reset to 1000 points, see you in 3 months..."
                        }
                    ]
                }
            ]
        end

        def season_summary_text
            "Number of game played: 115 (~28h) \n Number of votes: 120 \n Number of players: 112"
        end

        def podium_text
            ":crown: 1st place: #{elo_top_five[0].slack_username} \n :dolphin: 2nd place: #{elo_top_five[1].slack_username} \n :wood: 3rd place: #{elo_top_five[2].slack_username} \n \n 4th place: #{elo_top_five[3].slack_username} \n 5th place: #{elo_top_five[4].slack_username}"
        end

        # Todo for later;

        def other_awards_text
            texts = [most_played_text, most_correct_votes_text].compact
            texts.count <= 0 ? 'No special award for this season...' : texts.join('\n \n')
        end

        def most_played_text
            return nil if most_games_played_players.count <= 0

            players_text = most_games_played_players.map{|p| p.slack_username}.join(', ')
            "*:joystick: Player(s) who played the most with #{max_game_played} games (~#{(max_game_played * 0.25).round}h):* #{players_text}"
        end

        def most_correct_votes_text
            return nil if most_correct_votes_players.count <= 0

            players_text = most_correct_votes_players.map{|p| p.slack_username}.join(', ')
            "*:four_leaf_clover: Player(s) with the best guess on winners (#{max_correct_votes} correct votes):* #{players_text}"
        end
    end
end