import React from "react";
import styled from "styled-components";

import Stats from 'common/Stats'
import Player from 'common/Player'

import EloDiff from './FinishedLines/EloDiff'

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

const FinishedLines = ({ gamesPlayers }) => {
    const sortedScores = gamesPlayers.map(({ score }) => score).sort((a, b) => b - a)

    const withRank = gamesPlayers.map((gamesPlayers) => {
        const rank = sortedScores.indexOf(gamesPlayers.score) + 1
        return { rank: rank, ...gamesPlayers }
    }).sort(({ rank: rankA }, { rank: rankB }) => rankA - rankB)

    return (
        <>
            {withRank.map(({ score, player, eloDiff: elodiff, rank }) => (
                <PlayerLineContainer key={player.id}>
                    <PlayerLine>
                        <Rank>{rank}</Rank>
                        <EloDiff elodiff={elodiff} />
                        <Player {...player} />
                    </PlayerLine>
                    <div>
                        <Stats
                            stats={[
                                { title: 'GPts', value: score },
                                { title: 'Elo', value: player.elo },
                                { title: 'Rank', value: player.currentRank }
                            ]}
                        />
                    </div>
                </PlayerLineContainer>
            ))}
        </>
    )
}

export default FinishedLines;