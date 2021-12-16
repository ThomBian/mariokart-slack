module GraphQl
    class Types::VoteType < Types::BaseObject
        field :voted_by, Types::PlayerType, null: false
        field :correct, Boolean
        field :bet, Float, null:false

        def bet
            object.bet || 0
        end 
    end
end