module GraphQl
    class Types::PlayerType < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
        field :elo, Integer, null: false
        field :current_rank, Integer, null: false
        field :small_avatar_url, String
        field :medium_avatar_url, String
        field :games_played, Integer
        field :last_elo_diff, Integer
        field :avg_score, Integer
        field :money, Float, null: false
        field :elo_history, [Types::DataPointType], null: false
        field :score_history, [Types::DataPointType], null: false
        field :got_free, Boolean
        field :one_ones, [Types::OneOneType], null: false do
            argument :other_player_ids, [String]
        end

        field :achievements, [Types::AchievementType], null: false

        def achievements
            object.last_season_achievements
        end

        def elo_history
            object.elo_history.map{|p| {x: p[0].to_s, y: p[1].to_s}}
        end

        def score_history
            object.score_history.map{|p| {x: p[0].to_s, y: p[1].to_s}}
        end

        def got_free
            object.already_got_free_option_today?
        end

        def one_ones(other_player_ids:)
            puts other_player_ids
            other_player_ids.map do |other_player_id|
                other_player = Player.find(other_player_id)
                {
                    other_player: other_player,
                    chance_to_win: object.chance_to_win_against([other_player]),
                    game_outcomes: object.game_outcomes_against(other_player)
                }
            end
        end
    end
end