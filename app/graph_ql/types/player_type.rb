module GraphQl
    class Types::PlayerType < Types::BaseObject
        field :id, ID, null: false
        field :display_name, String, null: false
        field :elo, Integer, null: false
        field :current_rank, Integer, null: false
        field :small_avatar_url, String
        fiedl :medium_avatar_url, String
        field :games_played, Integer
        field :last_elo_diff, Integer
        field :avg_score, Integer
        field :elo_history, [Types::DataPointType], null: false

        field :achievements, [Types::AchievementType], null: false

        def display_name
            object.display_name || 'No name'
        end

        def games_played
            played.count
        end

        def last_elo_diff
            played.last.elo_diff
        end

        def avg_score
            (played.sum(:score) / played.count.to_f).round(2)
        end

        def achievements
            object.last_season_achievements
        end

        def elo_history
            object.elo_history.map{|p| {x: p[0].to_s, y: p[1].to_s}}
        end

        private 

        def played
            @played ||= object.games_players.joins(:game).where(game: {status: :saved})
        end
    end
end