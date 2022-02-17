module GraphQl
    class Types::OneOneType < Types::BaseObject
        field :other_player,  GraphQl::Types::PlayerType, null: false
        field :chance_to_win, Float, null: false
        field :game_outcomes, [String], null: false
    end
end