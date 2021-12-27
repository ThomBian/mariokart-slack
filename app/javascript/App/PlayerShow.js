import React from "react";
import styled from "styled-components";
import { useParams } from "react-router-dom";
import { useQuery } from '@apollo/client'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import { parseName, getNumberWithOrdinal } from 'utils/text'
import { round } from 'utils/number'
import { PLAYER } from "utils/queries";
import { cssQueries } from "basics/Media"

import Avatar from "basics/Avatar";

import { color as eloColor, icon as eloIcon } from "./Games/Game/FinishedLines/EloDiff"
import Achievement from "./PlayerShow/Achievement";
import LineGraph from "./PlayerShow/LineGraph";
import BarGraph from "./PlayerShow/BarGraph";


const Container = styled.div`
    display: flex;
    flex-direction: column;

    row-gap: 40px;

    @media ${cssQueries.mobile} {
        padding-top: 30px;
    }
`

const Name = styled.div`
    font-weight: bold;
    font-size: 18px;
`

const HeaderContainer = styled.div`
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 1fr;

    row-gap: 20px;
`

const Header = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 20px;
    }
`

const ProfileStats = styled.div`
    @media ${cssQueries.desktop} {
        display: flex;
        flex-direction: row;
        align-items: center;

        & > :not(:last-child) {
            margin-right: 20px;
        }
    }

    @media ${cssQueries.mobile} {
        & > :not(:last-child) {
            margin-bottom: 12px;
        }
    }
`

const Section = styled.div`
    display: flex;
    flex-direction: column;

    & > :not(:last-child) {
        margin-bottom: 12px;
    }
`

const Title = styled.div`
    font-weight: bold;
    font-size: 24px;
`

const Achievements = styled.div`
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    flex-grow: 1;
    flex-wrap: wrap;
    row-gap: 12px;

    & > :not(:last-child) {
        margin-right: 12px;
    }

    & > * {
        flex-grow: 1;
    }
`

const ProfileStatContainer = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 4px;
    }
`

const GraphsContainer = styled.div`
    & > :not(:last-child) {
        margin-bottom: 24px;
    }
`

const GraphTitle = styled.div`
    font-weight: bold;
    font-size: 20px;
`

const GraphContainer = styled.div`
    height: 300px;
`

const ProfileStat = ({ icon, children }) => (
    <ProfileStatContainer>
        <FontAwesomeIcon icon={icon} size="sm" />
        <div>{children}</div>
    </ProfileStatContainer>
)

const EloContainer = styled(ProfileStatContainer)`
    color: ${({ theme, elodiff }) => eloColor(elodiff, theme)};
    fill: ${({ theme, elodiff }) => eloColor(elodiff, theme)};
`

const Elo = ({ elo, elodiff }) => (
    <EloContainer elodiff={elodiff}>
        <FontAwesomeIcon icon="fan" size="sm" />
        <div>{`${elo} Pts`}</div>
        <div>{eloIcon(elodiff)}</div>
    </EloContainer>
)

const exist = (el, elements) => elements.indexOf(el) !== -1

const scoreToLeague = (score) => {
    if (score === 60) { return "perfect" }
    if (score >= 35) { return "ligue1" }
    if (score >= 30) { return "ligue2" }
    else { return "unacceptable" }
}

const groupScoreByLeague = (scores) => {
    return scores.reduce((memo, score) => {
        const key = scoreToLeague(score)
        memo[key] = memo[key] + 1
        return memo
    }, { "unacceptable": 0, "ligue2": 0, "ligue1": 0, "perfect": 0 })
}

const PlayerShow = ({ id }) => {
    const params = id ? { id } : useParams()

    const { loading, error, data } = useQuery(PLAYER, { variables: params });
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;

    const { player } = data
    const { achievements } = data
    const name = parseName(player.name)
    const achievementNames = player.achievements.map(({ name }) => name)

    const scoresByLeagues = groupScoreByLeague(player.scoreHistory.map(({ y }) => parseInt(y)))
    return (
        <Container>
            <HeaderContainer>
                <Header>
                    <Avatar size={88} name={name} src={player.mediumAvatarUrl} />
                    <Name>{name}</Name>
                </Header>
                <ProfileStats>
                    <ProfileStat icon={"crown"}>{getNumberWithOrdinal(player.currentRank)}</ProfileStat>
                    <Elo elo={player.elo} elodiff={player.lastEloDiff} />
                    <ProfileStat icon={"gamepad"}>{`${player.gamesPlayed} games played`}</ProfileStat>
                    {player.avgScore > 0 && <ProfileStat icon={"calculator"}>{`${player.avgScore} Pts / game`}</ProfileStat>}
                    <ProfileStat icon={"money-bill-alt"}>{`${round(player.money)} $Պ`}</ProfileStat>
                </ProfileStats>
            </HeaderContainer>
            <Section>
                <Title>Achievements</Title>
                <Achievements>
                    {achievements.map(({ name, ...props }) =>
                        <Achievement
                            key={name}
                            name={name}
                            active={exist(name, achievementNames)}
                            {...props}
                        />
                    )}
                </Achievements>
            </Section>
            {player && (player.eloHistory.length > 1 || player.scoreHistory.length > 0) &&
                <Section>
                    <Title>Stats</Title>
                    <GraphsContainer>
                        {player.eloHistory.length > 1 &&
                            <div>
                                <GraphTitle>Elo</GraphTitle>
                                <GraphContainer>
                                    <LineGraph data={{ id: 'elo', points: player.eloHistory }} />
                                </GraphContainer>
                            </div>
                        }

                        {player.scoreHistory.length > 0 &&
                            <div>
                                <GraphTitle>Score per games</GraphTitle>
                                <GraphContainer>
                                    <LineGraph data={{ id: 'score', points: player.scoreHistory }} />
                                </GraphContainer>
                            </div>
                        }

                        {player.scoreHistory.length > 0 &&
                            <div>
                                <GraphTitle>Leagues</GraphTitle>
                                <GraphContainer>
                                    <BarGraph data={{
                                        id: 'leagues',
                                        series: Object.keys(scoresByLeagues).map((key) => ({ "league": key, "games": scoresByLeagues[key] })),
                                        keys: ['games'],
                                        indexBy: 'league',
                                    }} />
                                </GraphContainer>
                            </div>
                        }
                    </GraphsContainer>
                </Section>
            }
        </Container>)
}

export default PlayerShow;