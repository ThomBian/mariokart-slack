import React from "react";
import styled from "styled-components";

import { round } from 'utils/number'

const Container = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;

    width: 100%;
`

const Name = styled.div`
    display: flex;
    width: 100px;

    font-weight: 500;
    font-size: 16px;
`

const OutcomesComtainer = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 4px;
    }
`

const outcomeColor = (value, theme) => {
    if (value == 'win') { return theme.colors.success2 }
    if (value == 'draw') { return theme.colors.primary3 }
    return theme.colors.danger3
}

const Outcome = styled.div`
    font-weight: bold;
    font-size: 14px;
    color: ${({ theme, value }) => outcomeColor(value, theme)}
`

const CTWContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 4px;
    }
`

const CTW = styled.div`
    font-weight: bold;
    font-size: 14px;
`

const CTWText = styled.div`
    font-size: 10px;
`

const OneOne = ({ otherPlayer, chanceToWin, gameOutcomes }) => {
    const filteredOutcomes = gameOutcomes.filter((value) => value !== 'unknown')
    // use of Comma operator: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_Operator
    const byOutcomes = filteredOutcomes.reduce((acc, value) => (acc[value] = (acc[value] || 0) + 1, acc), {})
    return (
        <Container>
            <Name>{otherPlayer.name}</Name>
            {filteredOutcomes.length > 0 ?
                (
                    <OutcomesComtainer>
                        <Outcome value={'win'}>{`${byOutcomes['win'] || 0}W`}</Outcome>
                        <div>-</div>
                        <Outcome value={'draw'}>{`${byOutcomes['draw'] || 0}D`}</Outcome>
                        <div>-</div>
                        <Outcome value={'loose'}>{`${byOutcomes['loose'] || 0}L`}</Outcome>
                    </OutcomesComtainer>
                ) : (
                    <OutcomesComtainer>No data...</OutcomesComtainer>
                )}
            <CTWContainer>
                <CTW>{`${round(chanceToWin * 100)}%`}</CTW>
                <CTWText>chance to win</CTWText>
            </CTWContainer>
        </Container>
    )
}

export default OneOne