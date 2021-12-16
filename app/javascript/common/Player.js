import React from "react";
import styled from "styled-components";

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
`

const parseName = (name) => name.replace(/[<|>|@]/gi, '');


const Player = ({ displayName, smallAvatarUrl }) => {
    const name = parseName(displayName)

    return (
        <Container>
            <Avatar src={smallAvatarUrl} name={name} />
            <Name>{name}</Name>
        </Container>
    )
}

export default Player