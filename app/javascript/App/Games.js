import React from 'react'
import { gql, useQuery } from '@apollo/client'

import Game from './Games/Game'

const GAMES = gql`
    query GetGames {
        games {
            status
            id
            players {
                id
                displayName
                elo
            }
        }
    }
`

const Games = () => {
    const { loading, error, data } = useQuery(GAMES);
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;
    return (
        <div>
            <h1>Games</h1>
            {
                data.games.map(({ id, ...props }) => <Game key={id} id={id} {...props} />)
            }
        </div>
    )
}

export default Games