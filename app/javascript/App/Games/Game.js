import React from "react"
import styled from "styled-components"

import { formatDateFull } from 'utils/date'
import FinishedLines from "./Game/FinishedLines"
import LiveLines from "./Game/LiveLines"

const Container = styled.div`
    padding: 16px;
    border: solid 1px ${({ theme }) => theme.colors.default1};
    border-radius: 2px;
`

const Header = styled.div`
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    margin-bottom: 8px;
`

const Title = styled.div`
    font-size: 20px;
    font-weight: 700;
`

const Status = styled.div`
    font-size: 13px;
    font-style: italic;
`

const Players = styled.div`
    & > :not(:last-child) {
        margin-bottom: 8px;
    }
`

const isSaved = (status) => status === 'saved'

const Game = ({ id, status, gamesPlayers, createdAt, ...props }) => {
    return (
        <Container {...props}>
            <Header>
                <Title>{`🏁 Game #${id}`}</Title>
                <Status>{isSaved(status) ? formatDateFull(createdAt) : 'Live!'}</Status>
            </Header>
            <Players>
                {isSaved(status)
                    ? <FinishedLines gamesPlayers={gamesPlayers} />
                    : <LiveLines gamesPlayers={gamesPlayers} />}
            </Players>
        </Container>
    )
}

export default Game