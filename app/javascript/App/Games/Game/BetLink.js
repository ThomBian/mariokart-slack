import React from "react";
import styled from "styled-components";

import { round, format } from 'utils/number'

import Modal from 'basics/Modal';
import Player from "common/Player";


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
const VoteLine = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;

    width: 100%;

    & > :last-child {
        font-weight: bold;
    }
`

const Line = styled.div`
    height: 1px;
    background: ${({ theme }) => theme.colors.default6};
    width: 100%;
`

const Addition = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    align-items: flex-start;
    width: 100%;

    font-weight: bold;
    font-size: 14px;
    line-height: 17px;
`

const colorLink = (theme, correct, live) => {
    if (live) { return theme.colors.primary3 }
    return correct ? theme.colors.success2 : theme.colors.danger2
}

const Link = styled.div`
    text-decoration-line: underline;
    color: ${({ theme, correct, live }) => colorLink(theme, correct, live)};
    cursor: pointer;
`

const Bet = ({ bet, odd, full }) => {
    if (full) {
        return <div>{`${round(odd)} * ${round(bet)} = ${round(odd * bet)}$Պ`}</div>
    } else {
        return <div>{`${round(bet)}$Պ`}</div>
    }
}

const BetLink = ({ votes, correct, live, odd }) => {
    const sum = votes.map(({ bet }) => bet).reduce((memo, cur) => memo + cur, 0)
    const allBets = live || correct ? sum * odd : sum

    return (
        <Modal
            trigger={(<Link correct={correct} live={live}>{`${format(allBets)}$Պ`}</Link>)}
            position={["left center", "bottom center"]}
            closeOnDocumentClick
            arrow={false}
            width={400}
        >
            <Container>
                <Title>Voters</Title>
                <Body>
                    {votes.map(({ id, bet, votedBy }) => (
                        <VoteLine key={id}>
                            <Player {...votedBy} />
                            <Bet bet={bet} odd={odd} full={correct || live} />
                        </VoteLine>
                    ))}
                    <Line />
                    <Addition><Bet bet={sum} odd={odd} full={correct || live} /></Addition>
                </Body>
            </Container>
        </Modal >
    )
}

export default BetLink;