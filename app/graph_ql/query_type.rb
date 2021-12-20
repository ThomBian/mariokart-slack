module GraphQl
    class QueryType < GraphQL::Schema::Object
        description "The query root of this schema"

        field :games, [Types::GameType], "Returns all games", null: false

        field :players, [Types::PlayerType], "Returns all players", null: false

        field :player, Types::PlayerType, "Returns a player" do
            argument :id, String
          end
        
        field :achievements, [Types::AchievementType], "Return all achievements", null: false

        def games(limit: 20)
            query = ::Game.all.order('created_at DESC').limit(limit)
        end

        def players
            ::Player.with_rank.all
        end

        def player(id:)
            Player.find(id)
        end

        def achievements
            Achievement.all.order(:id)
        end
    end
end