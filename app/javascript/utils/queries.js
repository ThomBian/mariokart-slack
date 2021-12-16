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
        }
    }
`

export { GAMES, PLAYERS }