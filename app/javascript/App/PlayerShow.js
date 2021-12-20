import React from "react";
import styled from "styled-components";
import { useParams } from "react-router-dom";
import { useQuery } from '@apollo/client'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import { parseName, getNumberWithOrdinal } from 'utils/text'
import { PLAYER } from "utils/queries";
import { cssQueries } from "basics/Media"

import Avatar from "common/Avatar";

import { color as eloColor, icon as eloIcon } from "./Games/Game/FinishedLines/EloDiff"
import Achievement from "./PlayerShow/Achievement";
import EloHistory from "./PlayerShow/EloHistory";


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

const PlayerShow = () => {
    const params = useParams();

    const { loading, error, data } = useQuery(PLAYER, { variables: params });
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;

    const { player } = data
    const { achievements } = data
    const name = parseName(player.displayName)
    const achievementNames = player.achievements.map(({ name }) => name)

    return (
        <Container>
            <HeaderContainer>
                <Header>
                    <Avatar size={88} name={name} src={player.smallAvatarUrl} />
                    <Name>{name}</Name>
                </Header>
                <ProfileStats>
                    <ProfileStat icon={"crown"}>{getNumberWithOrdinal(player.currentRank)}</ProfileStat>
                    <Elo elo={player.elo} elodiff={player.lastEloDiff} />
                    <ProfileStat icon={"gamepad"}>{`${player.gamesPlayed} games played`}</ProfileStat>
                    <ProfileStat icon={"calculator"}>{`${player.avgScore} Pts / game`}</ProfileStat>
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
            <Section>
                <Title>Stats</Title>
                <div>
                    <GraphTitle>Elo</GraphTitle>
                    <GraphContainer>
                        <EloHistory points={player.eloHistory} />
                    </GraphContainer>
                </div>
            </Section>
        </Container>)
}

export default PlayerShow;