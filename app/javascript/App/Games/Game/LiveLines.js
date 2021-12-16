import React from "react";
import styled from "styled-components";

import Player from 'common/Player'
import Stats from 'common/Stats'

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

const LiveLines = ({ gamesPlayers }) => {
    const sortedGps = gamesPlayers.slice().sort(({ player: playerA }, { player: playerB }) => playerB.elo - playerA.elo)

    return (
        <>
            {
                sortedGps.map(({ odd, player }) => (
                    <PlayerLineContainer key={player.id}>
                        <PlayerLine>
                            <Player key={player.id} {...player} />
                        </PlayerLine>
                        <div>
                            <Stats
                                stats={[
                                    { title: 'Elo', value: player.elo },
                                    { title: 'Odd', value: odd }
                                ]}
                            />
                        </div>
                    </PlayerLineContainer>
                ))
            }
        </>
    )
}

export default LiveLines