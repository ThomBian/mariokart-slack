import React from "react";
import PropTypes from 'prop-types'
import styled from "styled-components";

const CustomImg = styled.img`
    width: ${({size}) => size}px;
    height: ${({size}) => size}px;
    border-radius: 2px;
`

const PlaceholderContainer = styled.div`
    display: flex;
    justify-content: center;
    align-items: center;

    width: ${({size}) => size}px;
    height: ${({size}) => size}px;
    font-size: ${({size}) => size/2}px;

    border-radius: 2px;
    text-align: center;

    background: ${({ theme }) => theme.colors.black};
    color: ${({ theme }) => theme.colors.white};
`

const Placeholder = ({ name, size }) => {
    const twoLetters = name.slice(0, 1).toUpperCase()

    return (<PlaceholderContainer size={size}>{twoLetters}</PlaceholderContainer>)
}

const Avatar = ({ size, src, name }) => (src ? <CustomImg src={src} size={size}/> : <Placeholder name={name} size={size}/>)

Avatar.propTypes = {
    size: PropTypes.number,
    src: PropTypes.string,
    name: PropTypes.string.isRequired,
}

Avatar.defaultProps = {
    size: 24,
}

export default Avatar;