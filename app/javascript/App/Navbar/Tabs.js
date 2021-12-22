import React from "react";
import styled from "styled-components";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, useMatch, useResolvedPath } from "react-router-dom";

import SlackButton from "common/SlackButton";

import useCurrentUser from "context/CurrentUser"

const Title = styled.div`
    font-weight: bold;
    font-size: 18px;
`

const Group = styled.div`
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

const CustomLink = styled(Link)`
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
    text-decoration: none;

    &:hover {
        background: ${({ active, theme }) => !active && theme.colors.default1};
    }
`

const Tab = ({ children, to, ...props }) => {
    const resolved = useResolvedPath(to);
    const active = useMatch({ path: resolved.pathname, end: true });

    return (
        <CustomLink to={to} {...props} active={active}>
            {children}
        </CustomLink>
    )
}

const Container = styled.div`
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

const Tabs = ({ closeModal }) => {
    const { currentUser: { authenticated } } = useCurrentUser()

    return (
        <Container>
            {!authenticated && (
                < Group >
                    <SlackButton />
                </Group>
            )}

            {authenticated && (
                <Group>
                    <Title>My profile</Title>
                    <Tab to="/me" onClick={() => closeModal && closeModal()} >
                        <FontAwesomeIcon icon="laugh" size="sm" />
                        &nbsp;&nbsp;
                        <span>My stats</span>
                    </Tab>
                    <Tab to="/add-money" onClick={() => closeModal && closeModal()} >
                        <FontAwesomeIcon icon="money-bill-alt" size="sm" />
                        &nbsp;&nbsp;
                        <span>Add Money</span>
                    </Tab>
                </Group>
            )}

            <Group>
                <Title>History</Title>
                <Tab to="/games" onClick={() => closeModal && closeModal()} >
                    <FontAwesomeIcon icon="flag-checkered" size="sm" />
                    &nbsp;&nbsp;
                    <span>Games</span>
                </Tab>
                <Tab to="ranking" onClick={() => closeModal && closeModal()}>
                    <FontAwesomeIcon icon="crown" size="sm" />
                    &nbsp;&nbsp;
                    <span>Ranking</span>
                </Tab>
            </Group>
        </Container >
    )
}

export default Tabs;
