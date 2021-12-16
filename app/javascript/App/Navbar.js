import React from "react";
import styled from "styled-components";
import { Link, useMatch, useResolvedPath } from "react-router-dom";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import Logo from 'img/mario.svg'

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

const Title = styled.div`
    font-weight: bold;
    font-size: 18px;
`

const Tabs = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 0px;

    flex: none;
    order: 0;
    align-self: stretch;
    flex-grow: 0;

    & > :not(:last-child) {
        margin-bottom: 4px;
    }
`

const TabContainer = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 12px;

    flex: none;
    order: 0;
    align-self: stretch;
    flex-grow: 0;

    border-radius: 2px;

    background: ${({ active, theme }) => active && theme.colors.primary1};
    & > * { color: ${({ active, theme }) => active ? theme.colors.primary4 : theme.colors.primary6}; }
    & > svg { fill: ${({ active, theme }) => active ? theme.colors.primary4 : theme.colors.primary6}; }
`

const CustomLink = styled(Link)`
    text-decoration: none;
`

const Tab = ({ children, to, ...props }) => {
    const resolved = useResolvedPath(to);
    const active = useMatch({ path: resolved.pathname, end: true });

    return (
        <TabContainer active={active}>
            <CustomLink to={to} {...props}>{children}</CustomLink>
        </TabContainer>
    )
}

const TabsContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 0px;

    /* Inside Auto Layout */
    flex: none;
    order: 1;
    align-self: stretch;
    flex-grow: 0;

    & > :not(:last-child) {
        margin-bottom: 12px;
    }
`

const Navbar = () => (
    <Container>
        <LogoContainer>
            <Logo />
        </LogoContainer>

        <TabsContainer>
            <Tabs>
                <Title>History</Title>
                <Tab to="/">
                    <FontAwesomeIcon icon="flag-checkered" size="sm" />
                    &nbsp;&nbsp;
                    <span>Games</span>
                </Tab>
                <Tab to="ranking">
                    <FontAwesomeIcon icon="crown" size="sm" />
                    &nbsp;&nbsp;
                    <span>Ranking</span>
                </Tab>
            </Tabs>
        </TabsContainer>
    </Container>
)

export default Navbar