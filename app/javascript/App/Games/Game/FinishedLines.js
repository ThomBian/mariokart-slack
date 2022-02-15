import React from "react";
import styled from "styled-components";

import { cssQueries } from "basics/Media";

import Stats from 'common/Stats'
import Player from 'common/Player'

import BetLink from "./BetLink";
import EloDiff from './FinishedLines/EloDiff'

const PlayerLineContainer = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    width: 100%; 

    @media ${cssQueries.mobile} {
        flex-direction: column;
    }
`

const Line = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;
    width: 100%;

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
            {withRank.map(({ score, player, eloDiff: elodiff, rank, votes, odd }) => (
                <PlayerLineContainer key={player.id}>
                    <Line>
                        <Rank>{rank}</Rank>
                        <EloDiff elodiff={elodiff} />
                        <Player {...player} />
                    </Line>
                    <Line>
                        <Stats
                            stats={[
                                { title: 'GPts', value: score },
                                { title: 'Elo', value: player.elo },
                                { title: 'Rank', value: player.currentRank },
                                { title: 'Bets', value: (<BetLink odd={odd} votes={votes} correct={rank == 1} live={false} />) }
                            ]}
                        />
                    </Line>
                </PlayerLineContainer>
            ))}
        </>
    )
}

export default FinishedLines;