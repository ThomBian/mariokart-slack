import React, { useState } from "react";
import styled, { withTheme } from "styled-components";
import Select from 'react-select'
import { useMutation, useQuery } from '@apollo/client'

import Button from "basics/Button";

import { PLAYERS, ADD_MONEY } from "utils/queries";

const Form = styled.form`
    & > :not(:last-child) {
    margin-bottom: 8px;
}
`

const Group = styled.div`
    & > :not(:last-child) {
        display: block;
        margin-bottom: 8px;
    }
`

const Label = styled.label`
    font-size: 20px;
    font-weight: bold;
`

const Errors = styled.div`
    padding-bottom: 8px;
`

const Error = styled.div`
    color: ${({ theme }) => theme.colors.danger3}
`

const customStyles = {
    control: (provided, state) => {
        const customProps = state.selectProps
        const { hasErrors, colors } = customProps
        const borderColor = hasErrors ? colors.danger3 : provided.borderColor

        return { ...provided, borderColor: borderColor, borderRadius: '2px' }
    }
}

const AddMoney = ({ theme }) => {
    const [player, setPlayer] = useState();
    const [addMoney, { data: submittedData, loading: isSubmitting, error: formError }] = useMutation(ADD_MONEY);
    const { loading, error, data } = useQuery(PLAYERS);

    if (loading) return <p>Loading...</p>;
    if (error || formError) return <p>Error :(</p>;

    const options = data.players.map(({ id, displayName }) => ({ value: id, label: displayName }))
    const disabled = loading || isSubmitting
    const { addMoney: { money, errors } } = submittedData || { addMoney: { money: null, errors: [] } }
    const hasErrors = errors && errors.length > 0

    const handleSubmit = (event) => {
        addMoney({ variables: { value: parseInt(player.value) } })
        event.preventDefault()
    }

    return (
        <div>
            <h1>Add Money</h1>

            <Form onSubmit={handleSubmit}>
                <Group>
                    <Label>Player</Label>
                    <Select
                        options={options}
                        value={player}
                        onChange={(selectedOption) => setPlayer(selectedOption)}
                        placeholder="Select a player..."
                        styles={customStyles}
                        colors={theme.colors}
                        hasErrors={hasErrors}
                    />
                    {hasErrors && (
                        <Errors>
                            {errors.map((error) => <Error key={error}>{error}</Error>)}
                        </Errors>
                    )}
                </Group>

                <Button type="submit" disabled={disabled || !player}>Add money (5$Պ)</Button>
            </Form>

            {!hasErrors && money && (
                <div>{`Account has now ${money}$Պ!`}</div>
            )}
        </div>
    )
}

export default withTheme(AddMoney);