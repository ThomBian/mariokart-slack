import { gql } from "@apollo/client"

const GAMES = gql`
    query GetGames {
        games {
            status
            id
            createdAt
            gamesPlayers {
                score
                eloDiff
                odd
                player {
                    id
                    displayName
                    elo
                    currentRank
                    smallAvatarUrl
                }
                votes {
                    correct
                    bet
                    votedBy {
                        displayName
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
            displayName
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
            displayName
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


export { GAMES, PLAYERS, PLAYER, ADD_MONEY, CURRENT_USER, MONEY_OPTIONS }