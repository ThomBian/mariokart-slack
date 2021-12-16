import React from 'react'
import styled from "styled-components";
import { Link } from "react-router-dom";

import Logo from 'img/mario.svg'
import Tabs from './Tabs';

const Container = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 0px;

    & > :not(:last-child) {
        margin-bottom: 30px;
    }
`

const LogoContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 8px;
    
    background: #FFD4D4;
    border-radius: 4px;

    & > img {
        width: 48px;
        height: 48px;
    }
`

const NavbarContainer = styled.div`
    position: fixed;
    width: 200px;
    height: 100%; 
    z-index: 1; 
    top: 0; 
    left: 0;
    padding: 50px 16px 16px;
`

const Desktop = () => (
    <NavbarContainer>
        <Container>
            <LogoContainer>
                <Link to="/">
                    <Logo />
                </Link>
            </LogoContainer>

            <Tabs />
        </Container>
    </NavbarContainer>
)

export default Desktop