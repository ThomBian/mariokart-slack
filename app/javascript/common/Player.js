import React from "react";
import styled from "styled-components";

const Name = styled.div`
    font-size: 20px;
`

const parseName = (name) => name.replace(/[<|>|@]/gi, '');

const Player = ({ displayName }) => (<Name>{`${parseName(displayName)}`}</Name>)

export default Player