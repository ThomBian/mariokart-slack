import React from "react";
import styled from "styled-components";
import { useNavigate } from "react-router-dom";

import { parseName } from 'utils/text'
import useCurrentUser from "context/CurrentUser";

import Avatar from "basics/Avatar";
import { SmallAchievement } from "App/PlayerShow/Achievement";

const Container = styled.div`
    display: flex;
    align-items: center;
    cursor: pointer;

    & > :not(:last-child) {
        margin-right: 4px;
    }

    &:hover {
        color: ${({ theme }) => theme.colors.primary3}; 
    }
`

const Name = styled.div`
    font-size: 20px;
    display: flex;
    align-items: center;

    font-weight: ${({ isCurrent }) => isCurrent && 'bold'};
`

const Player = ({ id, name, smallAvatarUrl, achievements }) => {
    const navigate = useNavigate();
    const { loading, currentUser } = useCurrentUser()

    const parsedName = parseName(name)
    const isCurrent = !loading && currentUser && currentUser.player && currentUser.player.id == id
    const displayName = isCurrent ? `${parsedName} (me)` : parsedName

    const redirectUrl = isCurrent ? '/me' : `/player/${id}`

    return (
        <>
            <Container onClick={() => navigate(redirectUrl)}>
                <Avatar src={smallAvatarUrl} name={name} />
                <Name isCurrent={isCurrent}>{displayName}</Name>
                {achievements && achievements.length > 0 && (
                    <div>
                        {achievements.map((achievement) => <SmallAchievement key={achievement.name} {...achievement} />)}
                    </div>
                )}
            </Container>
        </>
    )
}

export default Player