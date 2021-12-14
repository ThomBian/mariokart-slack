module GraphQl
    class Types::PlayerType < Types::BaseObject
        field :id, ID, null: false
        field :display_name, String, null: false
        field :elo, Integer, null: false
    end
end