import { gql } from "@apollo/client"

const GAMES = gql`
    query GetGames($cursor: String, $playerId: String) {
        games(cursor: $cursor, playerId: $playerId) {
            totalCount
            edges {
                node {
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
                            achievements {
                                emoji
                                name
                            }
                        }
                        votes {
                            id
                            correct
                            bet
                            votedBy {
                                id
                                name
                                smallAvatarUrl
                            }
                        }
                    }
                }
                cursor
            }
            pageInfo {
                hasNextPage
                startCursor
            }
        }
    }
`

const PLAYERS = gql`
    query GetPlayers($term: String) {
        players(term: $term) {
            id
            name
            elo
            smallAvatarUrl
            achievements {
                name
                emoji
            }
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
        },
    }
`;

const ONE_ONES = gql`
    query GetOneOnes($playerId: String!, $otherPlayerIds: [String!]!) {
        player(id: $playerId) {
            name
            oneOnes(otherPlayerIds: $otherPlayerIds) {
                otherPlayer {
                    id
                    name
                }
                chanceToWin,
                gameOutcomes
            }
        }
    }
`


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
                id
                correct
                bet
                votedBy {
                    id
                    name
                }
            }
            errors
        }
    }
`

export { GAMES, PLAYERS, PLAYER, ADD_MONEY, CURRENT_USER, MONEY_OPTIONS, VOTE, ONE_ONES }