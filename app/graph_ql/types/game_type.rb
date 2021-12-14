module GraphQl
    class Types::GameType < Types::BaseObject
        field :id, ID, null: false
        field :status, String, null: false
        field :players, [Types::PlayerType], null: false
    end
end