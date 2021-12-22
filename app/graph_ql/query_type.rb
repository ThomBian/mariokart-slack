module GraphQl
    class QueryType < GraphQL::Schema::Object
        description "The query root of this schema"

        field :games, [Types::GameType], "Returns all games", null: false

        field :players, [Types::PlayerType], "Returns all players", null: false

        field :player, Types::PlayerType, "Returns a player" do
            argument :id, String
        end
        
        field :achievements, [Types::AchievementType], "Return all achievements", null: false

        field :current_user, Types::UserType, null: false

        def games(limit: 20)
            query = ::Game.includes(games_players: [:player, votes: :voted_by]).all.order('created_at DESC').limit(limit)
        end

        def players
            ::Player.includes(:achievements).with_rank.all
        end

        def player(id:)
            Player.includes(players_achievements: [:achievement, :season]).find(id)
        end

        def achievements
            Achievement.all.order(:id)
        end

        def current_user
            return {} unless context[:current_user].present?
            context[:current_user]
        end
    end
end