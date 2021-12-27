module GraphQl
    class Mutations::Vote < Mutations::BaseMutation
        null true
        argument :game_player_id, ID
        argument :bet, Float

        field :errors, [String], null: false
        field :vote, Types::VoteType

        def resolve(game_player_id:, bet:)
            return {vote: nil, errors: ['Oops, something went wrong (not signed in)']} if current_user.nil?
            game_player = GamesPlayers.find(game_player_id)

            return {vote: nil, errors: ['Oops. something went wrong (game is over)']} if game_player.nil?
            voter = current_user.player
            result = voter.vote(game_player, bet)
            return { vote: nil, errors: [result[:message]] } if result[:error]
            
            { vote: result[:vote], errors: [] }
        end
    end
end