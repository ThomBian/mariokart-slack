module GraphQl
    class Types::GameType < Types::BaseObject
        field :id, ID, null: false
        field :status, String, null: false
        field :players, [Types::PlayerType], null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false

        field :games_players, [Types::GamesPlayersType], null: false
    end
end