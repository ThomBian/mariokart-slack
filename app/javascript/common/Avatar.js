import React from "react";
import styled from "styled-components";

const CustomImg = styled.img`
    width: 20px;
    height: 20px;
    border-radius: 2px;
`

const NoSrcAvatarContainer = styled.div`
    width: 12px;
    height: 12px;
    border-radius: 2px;
    text-align: center;
    padding: 4px;

    background: ${({ theme }) => theme.colors.black};
    color: ${({ theme }) => theme.colors.white};
`

const NoSrcAvatar = ({ name }) => {
    const twoLetters = name.slice(0, 1).toUpperCase()

    return (<NoSrcAvatarContainer>{twoLetters}</NoSrcAvatarContainer>)
}

const Avatar = ({ src, name }) => (src ? <CustomImg src={src} /> : <NoSrcAvatar name={name} />)

export default Avatar;