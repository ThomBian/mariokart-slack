import React from 'react';
import styled from 'styled-components';
import { useQuery } from '@apollo/client'

import { ONE_ONES } from 'utils/queries'

import Modal from 'basics/Modal';

import OneOne from './OneOne';

const Container = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 12px;
`

const Title = styled.div`
    font-style: normal;
    font-weight: bold;
    font-size: 18px;
    line-height: 22px;
`
const Body = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    width: 100%;

    & > :not(:last-child) {
        margin-bottom: 4px;
    }
`

const Link = styled.div`
    text-decoration-line: underline;
    color: ${({ theme }) => theme.colors.primary3};
    cursor: pointer;
`

const OddModalContent = ({ playerId, otherPlayerIds }) => {
    const { loading, error, data } = useQuery(ONE_ONES, { variables: { playerId, otherPlayerIds } });
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;
    const { player: { name, oneOnes } } = data
    return (
        <Container>
            <Title>{`${name} vs ...`}</Title>
            <Body>
                {oneOnes.map((oneOne) => <OneOne key={oneOne.otherPlayer.id} {...oneOne} />)}
            </Body>
        </Container>
    )
}

const OddLink = ({ otherPlayerIds, playerId, odd }) => {
    return (
        <Modal
            trigger={(<Link>{odd}</Link>)}
            position={["left center", "bottom center"]}
            closeOnDocumentClick
            arrow={false}
            width={350}
        >
            <OddModalContent otherPlayerIds={otherPlayerIds} playerId={playerId} />
        </Modal >
    )
}

export default OddLink;