import React from "react";
import styled from "styled-components";

const CustomImg = styled.img`
    width: 24px;
    height: 24px;
    border-radius: 2px;
`

const PlaceholderContainer = styled.div`
    display: flex;
    justify-content: center;
    align-items: center;

    width: 24px;
    height: 24px;
    font-size: 12px;

    border-radius: 2px;
    text-align: center;

    background: ${({ theme }) => theme.colors.black};
    color: ${({ theme }) => theme.colors.white};
`

const Placeholder = ({ name }) => {
    const twoLetters = name.slice(0, 1).toUpperCase()

    return (<PlaceholderContainer>{twoLetters}</PlaceholderContainer>)
}

const Avatar = ({ src, name }) => (src ? <CustomImg src={src} /> : <Placeholder name={name} />)

export default Avatar;