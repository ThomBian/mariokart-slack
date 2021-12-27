import React from "react";
import styled from "styled-components";

import Player from 'common/Player'
import Stats from 'common/Stats'

import VoteButton from "./LiveLines/VoteButton";

const PlayerLineContainer = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
`
const Line = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 12px;
    }
`

const LiveLines = ({ gamesPlayers }) => {
    const sortedGps = gamesPlayers.slice().sort(({ player: playerA }, { player: playerB }) => playerB.elo - playerA.elo)

    return (
        <>
            {
                sortedGps.map(({ id, odd, player }) => (
                    <PlayerLineContainer key={player.id}>
                        <Line>
                            <Player key={player.id} {...player} />
                        </Line>
                        <Line>
                            <Stats stats={[
                                { title: 'Elo', value: player.elo },
                                { title: 'Odd', value: odd }
                            ]}
                            />
                            <VoteButton id={id} odd={odd} player={player} />
                        </Line>
                    </PlayerLineContainer>
                ))
            }
        </>
    )
}

export default LiveLines