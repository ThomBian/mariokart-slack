import React from "react"
import styled from "styled-components"

import { formatDateFull } from 'utils/date'

import Player from 'common/Player'

import EloDiff from './Game/EloDiff'
import Stats from 'common/Stats'

const Container = styled.div`
    padding: 16px;
    border: solid 1px ${({ theme }) => theme.colors.default1};
    border-radius: 2px;
`

const Header = styled.div`
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    margin-bottom: 8px;
`

const Title = styled.div`
    font-size: 20px;
    font-weight: 700;
`

const Status = styled.div`
    font-size: 13px;
    font-style: italic;
`

const Players = styled.div`
    & > :not(:last-child) {
        margin-bottom: 8px;
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
`

const Game = ({ id, status, gamesPlayers, createdAt, ...props }) => {
    const sortedScores = gamesPlayers.map(({ score }) => score).sort((a, b) => b - a)

    const withRank = gamesPlayers.map((gamesPlayers) => {
        const rank = sortedScores.indexOf(gamesPlayers.score) + 1
        return { rank: rank, ...gamesPlayers }
    }).sort(({ rank: rankA }, { rank: rankB }) => rankA - rankB)

    return (
        <Container {...props}>
            <Header>
                <Title>{`🏁 Game #${id}`}</Title>
                <Status>{formatDateFull(createdAt)}</Status>
            </Header>
            <Players>
                {withRank.map(({ score, player, eloDiff: elodiff, rank, ...props }) =>
                (
                    <PlayerLineContainer key={player.id}>
                        <PlayerLine>
                            <Rank>{rank}</Rank>
                            <EloDiff elodiff={elodiff} />
                            <Player {...player} {...props} />
                        </PlayerLine>
                        <div>
                            <Stats
                                stats={[
                                    { title: 'Pts', value: score },
                                    { title: 'Elo', value: player.elo },
                                    { title: 'Rank', value: player.currentRank }
                                ]} />
                        </div>
                    </PlayerLineContainer>
                )
                )}
            </Players>
        </Container>
    )
}

export default Game