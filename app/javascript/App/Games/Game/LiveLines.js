import React, { useState } from "react";
import styled from "styled-components";

import { cssQueries } from "basics/Media";

import Player from 'common/Player'
import Stats from 'common/Stats'

import useCurrentUser from 'context/CurrentUser'

import VoteButton from "./LiveLines/VoteButton";
import OddLink from './LiveLines/OddLink';
import BetLink from './BetLink';

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

    & > :not(:last-child) {
        margin-right: 12px;
    }

    width: 100%;
`

const playerStats = ({ elo, odd, votes }, playerId, otherPlayerIds, authenticated, hasVoted) => {
    const stats = [
        { title: 'Elo', value: elo },
        { title: 'Odd', value: <OddLink odd={odd} otherPlayerIds={otherPlayerIds} playerId={playerId} /> },
    ]
    if (!authenticated || hasVoted) {
        stats.push({ title: 'Bets', value: <BetLink votes={votes} correct={false} live={true} odd={odd} /> })
    }
    return stats
}

const LiveLines = ({ gamesPlayers: gPlayers }) => {
    const [gamesPlayers, setGamesPlayers] = useState(gPlayers)

    const sortedGps = gamesPlayers.slice().sort(({ player: playerA }, { player: playerB }) => playerB.elo - playerA.elo)
    const { currentUser: { authenticated, player } } = useCurrentUser()
    const hasVoted = authenticated && player && gamesPlayers.map(({ votes }) => votes).flat().findIndex(({ votedBy: { id } }) => id == player.id) !== -1

    const handleOnVote = (gamePlayerId, vote) => {
        setGamesPlayers((prevState) => prevState.map(
            (gp) => (gp.id == gamePlayerId ? { ...gp, votes: [...gp.votes, vote] } : { ...gp })
        ))
    }

    return (
        <>
            {
                sortedGps.map(({ id, player, odd, votes }) => {
                    const otherPlayerIds = sortedGps.filter(({ player: p }) => p.id !== player.id).map(({ player: { id } }) => id)
                    return (
                        <PlayerLineContainer key={player.id}>
                            <Line>
                                <Player key={player.id} {...player} />
                            </Line>
                            <Line>
                                <Stats stats={playerStats({ elo: player.elo, odd, votes }, player.id, otherPlayerIds, authenticated, hasVoted)} />
                                {authenticated && !hasVoted && <VoteButton id={id} odd={odd} player={player} onVote={handleOnVote} />}
                            </Line>
                        </PlayerLineContainer>
                    )
                })
            }
        </>
    )
}

export default LiveLines