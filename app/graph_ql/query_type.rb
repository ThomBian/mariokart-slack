module GraphQl
    class QueryType < GraphQL::Schema::Object
        description "The query root of this schema"

        field :game, Types::GameType, "Find a game by id" do
            argument :id, ID
        end


        field :games, [Types::GameType], "Returns all games", null: false

        def game(id:)
            ::ModelsGame.find(id)
        end

        def games
            ::Game.all
        end
    end
end