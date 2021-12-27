import React, { useState } from 'react'
import styled from 'styled-components'
import { useMutation } from "@apollo/client";

import useCurrentUser from 'context/CurrentUser'
import useFlashAlerts from 'context/FlashAlerts'

import { ALERT_TYPES } from 'basics/Alert'
import Popup from 'basics/Popup';
import Button from 'basics/Button';

import { VOTE } from 'utils/queries'
import { round } from 'utils/number'

const Container = styled.form`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 12px;

    & > :not(:last-child) {
        margin-bottom: 12px;
    }
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

const Line = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;

    width: 100%;

    & > :last-child {
        font-weight: bold;
    }
`

const BetLine = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    width: 100%;

    & > :not(:last-child) {
        margin-bottom: 2px;
    }
`

const BetInput = styled.input`
    width: 100px;
`

const MaxBet = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    font-size: 10px;
    line-height: 12px;

    text-align: right;

    width: 100%
`

const PlaceButton = styled(Button)`
    width: 100%;
`

const Trigger = styled(Button)`
    width: 100px;
`

const VoteButton = ({ id, odd, player, onVote }) => {
    const { currentUser: { authenticated, player: currentPlayer } } = useCurrentUser()
    const { add } = useFlashAlerts()
    const [vote, { errors, loading }] = useMutation(VOTE)
    const [bet, setBet] = useState(0)

    if (errors) { return <div>Error :(</div> }
    const trigger = ({ open }) => <Trigger disabled={open || !authenticated}>Vote</Trigger>

    if (!authenticated || !currentPlayer) { return trigger({ open: false }) }
    return (
        <Popup
            trigger={open => trigger({ open })}
            position="left center"
            closeOnDocumentClick
            arrow={false}
        >
            {close => (
                <Container onSubmit={(event) => {
                    vote({
                        variables: { gamePlayerId: parseInt(id), bet: parseFloat(bet) },
                        onCompleted: ({ vote: { errors, vote } }) => {
                            if (errors.length > 0) { errors.forEach((error) => add({ type: ALERT_TYPES.danger, text: error })) }
                            else {
                                close()
                                setBet(0)
                                add({ type: ALERT_TYPES.success, text: `You have bet ${vote.bet}$Պ on ${player.name}!` })
                                onVote(id, vote)
                            }
                        }
                    })
                    event.preventDefault();
                }}>
                    <Title>{`Vote for ${player.name}`}</Title>
                    <Body>
                        <Line><div>Odd:</div><div>{odd}</div></Line>
                        <BetLine>
                            <Line>
                                <div>Your bet:</div>
                                <BetInput
                                    type="number"
                                    value={bet}
                                    onChange={(e) => {
                                        const newBet = e.target.value
                                        if (newBet < 0) { setBet(0) }
                                        else if (newBet > currentPlayer.money) { setBet(currentPlayer.money) }
                                        else { setBet(e.target.value) }
                                    }}
                                    min={0}
                                    max={currentPlayer.money}
                                />
                            </Line>
                            <MaxBet>{`max: ${round(currentPlayer.money)}$Պ`}</MaxBet>
                        </BetLine>
                        <Line><div>Potential gains:</div><div>{`${round(odd * bet)}$Պ`}</div></Line>
                        <PlaceButton disabled={loading || bet == 0} type="submit">
                            Confirm
                        </PlaceButton>
                    </Body>
                </Container>
            )}
        </Popup>
    )
}

export default VoteButton