module Concern
    module Extensions
        module Player::Vote
            def vote(games_players, bet)
                return {error: true, message: 'You have already voted!', vote: nil} if has_already_voted?(games_players.game)
                return {error: true, message: 'You do not have enough money!', vote: nil} if money < bet
                return {error: true, message: 'Take some risk, you cannot vote 0 $Պ!', vote: nil} if bet == 0

                vote = ::Vote.create!({games_players: games_players, game: games_players.game, bet: bet})
                votes << vote

                update money: money - bet
                
                {error: false, message: nil, vote: vote}
            end
        end
    end
end