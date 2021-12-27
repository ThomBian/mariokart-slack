module GraphQl
    class Types::GamesPlayersType < Types::BaseObject
        field :id, ID
        field :score, Integer
        field :elo_diff, Integer
        field :odd, Float

        field :player, Types::PlayerType, null: false
        field :votes, [Types::VoteType], null: false
    end 
end