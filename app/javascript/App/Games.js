import React from 'react'
import styled from 'styled-components'
import { useQuery } from '@apollo/client'

import { GAMES } from 'utils/queries'

import Game from './Games/Game'

const Container = styled.div`
    & > :not(:last-child) {
        margin-bottom: 12px;
    }
`

const Games = () => {
    const { loading, error, data } = useQuery(GAMES);
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;
    return (
        <div>
            <h1>Games</h1>
            <Container>
            {
                data.games.map(({ id, ...props }) => <Game key={id} id={id} {...props} />)
            }
            </Container>
        </div>
    )
}

export default Games