import { gql } from "@apollo/client"

const GAMES = gql`
    query GetGames {
        games {
            status
            id
            createdAt
            gamesPlayers {
                id
                score
                eloDiff
                odd
                player {
                    id
                    name
                    elo
                    currentRank
                    smallAvatarUrl
                }
                votes {
                    correct
                    bet
                    votedBy {
                        name
                    }
                }
            }
        }
    }
`

const PLAYERS = gql`
    query GetPlayers {
        players {
            id
            name
            elo
            currentRank
            smallAvatarUrl
        }
    }
`

const PLAYER = gql`
    query GetPlayer($id: String!) {
        player(id: $id) {
            id
            name
            elo
            currentRank
            smallAvatarUrl
            mediumAvatarUrl
            gamesPlayed
            lastEloDiff
            avgScore
            money
            eloHistory {
                x
                y
            }
            scoreHistory {
                x
                y
            }
            achievements {
                name
            }
        },
        achievements {
            name
            emoji
        }
    }
`;

const ADD_MONEY = gql`
    mutation AddMoney($id: ID!) {
        addMoney(moneyOptionId: $id) {
            moneyOption {
                value
                price
            }
            errors
        }
    }
`

const CURRENT_USER = gql`
    query GetCurrentUser {
        currentUser {
            id
            name
            authenticated
            player {
                id
                gotFree
                money
            }
        }
    }
`

const MONEY_OPTIONS = gql`
    query GetMoneyOptions {
        moneyOptions {
            id
            title
            value
            price
        }
    }
`

const VOTE = gql`
    mutation Vote($gamePlayerId: ID!, $bet: Float!) {
        vote(gamePlayerId: $gamePlayerId, bet: $bet) {
            vote {
                bet
            }
            errors
        }
    }
`

export { GAMES, PLAYERS, PLAYER, ADD_MONEY, CURRENT_USER, MONEY_OPTIONS, VOTE }