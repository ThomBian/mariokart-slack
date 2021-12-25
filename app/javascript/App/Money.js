import React from "react";
import styled from "styled-components";
import { useQuery, useMutation } from "@apollo/client";

import useCurrentUser from 'context/CurrentUser'
import useFlashAlerts from 'context/FlashAlerts'
import { cssQueries } from 'basics/Media'

import { MONEY_OPTIONS, ADD_MONEY } from 'utils/queries'
import { ALERT_TYPES } from 'basics/Alert'

import AddMoneyOption from "./Shop/AddMoneyOption";

const AddMoneyOptions = styled.div`
    display: grid;

    @media ${cssQueries.desktop} {
        grid-template-columns: 1fr 1fr 1fr 1fr 1fr;
        gap: 8px;
    }

    @media ${cssQueries.mobile} {
        grid-template-columns: 1fr;
        gap: 8px;
    }
`

const Money = () => {
    const { loaded, currentUser, setCurrentUser } = useCurrentUser()
    const { loading: loadingMoneyOption, error: errorsMoneyOption, data: dataMoneyOptions } = useQuery(MONEY_OPTIONS);
    const [addMoney, { data: submittedData, loading: isSubmitting, error: formError }] = useMutation(ADD_MONEY);
    const { add } = useFlashAlerts()

    if (loadingMoneyOption) { return <div>Loading...</div> }
    if (errorsMoneyOption || formError) { return <div>Error :(</div> }

    const playerGotFree = currentUser.player && currentUser.player.gotFree
    console.log({ currentUser })

    const disabled = !loaded || !currentUser.player || !currentUser.authenticated

    return (
        <div>
            <h1>Add money</h1>

            <AddMoneyOptions>
                {dataMoneyOptions.moneyOptions.map((option) => (
                    <AddMoneyOption
                        key={option.title}
                        {...option}
                        disabled={isSubmitting || disabled || (option.price == 0 && playerGotFree)}
                        playerId={currentUser && currentUser.player && currentUser.player.id}
                        onClick={() => addMoney({
                            variables: { id: parseInt(option.id) },
                            onCompleted: ({ addMoney: { errors, moneyOption } }) => {
                                const hasError = errors.length > 0
                                const isOptionFree = moneyOption && moneyOption.price == 0

                                if (hasError) { errors.forEach((error) => add({ type: ALERT_TYPES.danger, text: error })) }
                                if (!hasError) {
                                    add({ type: ALERT_TYPES.success, text: `You have successfully got ${moneyOption.value}$Պ!` })
                                    if (isOptionFree) { setCurrentUser((prev) => ({ ...prev, player: { ...prev.player, gotFree: true } })) }
                                }
                            }
                        })}
                    />))}
            </AddMoneyOptions>
        </div>
    )
}

export default Money