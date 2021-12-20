import React from "react";
import styled from "styled-components";
import { useNavigate } from "react-router-dom";

import { parseName } from 'utils/text'

import Avatar from "./Avatar";

const Container = styled.div`
    display: flex;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 4px;
    }
`

const Name = styled.div`
    font-size: 20px;
    display: flex;
    align-items: center;
    cursor: pointer;
`

const Player = ({ id, displayName, smallAvatarUrl }) => {
    const name = parseName(displayName)
    const navigate = useNavigate();

    return (
        <>
            <Container>
                <Avatar src={smallAvatarUrl} name={name} />
                <Name onClick={() => navigate(`/player/${id}`)}>{name}</Name>
            </Container>
        </>
    )
}

export default Player