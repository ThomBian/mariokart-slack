import React from "react";
import styled from "styled-components";
import { useNavigate } from "react-router-dom";

import { parseName } from 'utils/text'
import useCurrentUser from "context/CurrentUser";


import Avatar from "basics/Avatar";

const Container = styled.div`
    display: flex;
    align-items: center;

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
    cursor: pointer;

    font-weight: ${({ isCurrent }) => isCurrent && 'bold'};
`

const Player = ({ id, displayName, smallAvatarUrl }) => {
    const navigate = useNavigate();
    const { loading, currentUser } = useCurrentUser()

    const parsedName = parseName(displayName)
    const isCurrent = !loading && currentUser && currentUser.player && currentUser.player.id == id
    const name = isCurrent ? `${parsedName} (me)` : parsedName

    const redirectUrl = isCurrent ? '/me' : `/player/${id}`

    return (
        <>
            <Container>
                <Avatar src={smallAvatarUrl} name={name} />
                <Name isCurrent={isCurrent} onClick={() => navigate(redirectUrl)}>{name}</Name>
            </Container>
        </>
    )
}

export default Player