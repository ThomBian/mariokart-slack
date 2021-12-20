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
    return (
        <div>
            <h1>Ranking</h1>
            <Container>
                {
                    data.players.map(({ id, currentRank, displayName, smallAvatarUrl, elo }) => (
                        <PlayerLineContainer key={id}>
                            <PlayerLine>
                                <Rank>{currentRank}</Rank>
                                <Player
                                    key={id}
                                    id={id}
                                    displayName={displayName}
                                    smallAvatarUrl={smallAvatarUrl}
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