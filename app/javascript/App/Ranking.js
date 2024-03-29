import React from 'react'
import styled from 'styled-components'
import { useQuery } from '@apollo/client'

import { PLAYERS } from 'utils/queries'

import Player from 'common/Player'
import Stats from 'common/Stats'

const Container = styled.div`
    & > :not(:last-child) {
        margin-bottom: 12px;
    }
`

const PlayerLineContainer = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
`

const PlayerLine = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 12px;
    }
`

const Rank = styled.div`
    font-weight: bold;
    font-size: 24px;
    width: 50px;
`

const Ranking = () => {
    const { loading, error, data } = useQuery(PLAYERS);
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;

    const { players } = data
    const sortedElos = players.map(({ elo }) => elo).sort((a, b) => b - a)
    const withRank = players.map((player) => {
        const rank = sortedElos.indexOf(player.elo) + 1
        return { currentRank: rank, ...player }
    })
    return (
        <div>
            <h1>Ranking</h1>
            <Container>
                {
                    withRank.map(({ id, currentRank, elo, ...props }) => (
                        <PlayerLineContainer key={id}>
                            <PlayerLine>
                                <Rank>{currentRank}</Rank>
                                <Player
                                    key={id}
                                    id={id}
                                    {...props}
                                />
                            </PlayerLine>
                            <div>
                                <Stats stats={[{ title: 'Elo', value: elo }]} />
                            </div>
                        </PlayerLineContainer>
                    ))
                }
            </Container>
        </div>
    )
}

export default Ranking