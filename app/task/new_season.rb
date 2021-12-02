module Task
    class NewSeason
        def process
            Season.transaction do
                @current_season = Season.current

                save_achievements
                post_message
                reset_score
                create_new_season
            end
        end

        private

        def save_achievements
            # podium
            # TODO later: handle same rank
            elo_top_five[0].players_achievements << PlayersAchievements.new(achievement: Achievement.find_by(name: '1st place'), season: @current_season)
            elo_top_five[1].players_achievements << PlayersAchievements.new(achievement: Achievement.find_by(name: '2nd place'), season: @current_season)
            elo_top_five[2].players_achievements << PlayersAchievements.new(achievement: Achievement.find_by(name: '3rd place'), season: @current_season)
            

            # most game played
            most_games_played_players.each do |p|
                p.players_achievements << PlayersAchievements.new(achievement: Achievement.find_by(name: 'Most games'), season: @current_season)
            end

            # most correct votes
            most_correct_votes_players.each do |p|
                p.players_achievements << PlayersAchievements.new(achievement: Achievement.find_by(name: 'Most correct votes'), season: @current_season)
            end
        end

        def elo_top_five
            @elo_top_five ||= @current_season.top_players
        end

        def most_games_played_players
            @most_games_played_players ||= @current_season.most_games_players
        end


        def most_correct_votes_players
            @most_correct_votes_players ||= @current_season.most_correct_votes_players
        end

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
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": season_summary_text
                    }
                },
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
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": ":eyes: Other awards",
                        "emoji": true
                    }
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": other_awards_text
                    }
                },
                {
                    "type": "divider"
                },
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
            nb_games = @current_season.number_of_games
            nb_votes = @current_season.votes.count
            nb_players = @current_season.number_of_players
            "Number of games played: #{nb_games} (~#{(nb_games*0.25).round}h) \n Number of players: #{nb_players} \n Number of votes: #{nb_votes}"
        end

        TEXTS = [':crown: 1st place:', ':dolphin: 2nd place:', ':wood: 3rd place:', '4th place:', '5th place:']
        def podium_text
            elo_top_five.map.with_index {|p, i| [TEXTS[i], p.slack_username].join(' ')}.join("\n")
        end

        def other_awards_text
            texts = [most_played_text, most_correct_votes_text].compact
            texts.count <= 0 ? 'No special award for this season...' : texts.join("\n \n")
        end

        def most_played_text
            return nil if @current_season.number_of_games <= 0

            max_games = @current_season.max_games_played
            players_text = most_games_played_players.map{|p| p.slack_username}.join(', ')
            "*:joystick: Player(s) who played the most with #{max_games} games (~#{(max_games * 0.25).round}h):* #{players_text}"
        end

        def most_correct_votes_text
            return nil if @current_season.max_correct_votes <= 0

            players_text = most_correct_votes_players.map{|p| p.slack_username}.join(', ')
            "*:four_leaf_clover: Player(s) with the best guess on winners (#{@current_semax_correct_votes} correct votes):* #{players_text}"
        end

        def create_new_season
            current = @current_season
            current.update is_current: false

            Season.new(is_current: true).save!
        end
    end
end