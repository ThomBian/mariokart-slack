import React from "react"
import styled from "styled-components"

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

const icon = (elodiff) => {
    if (elodiff > 0) { return <FontAwesomeIcon icon='caret-up' size="xs" /> }
    if (elodiff < 0) { return <FontAwesomeIcon icon='caret-down' size="xs" /> }
    return <FontAwesomeIcon icon='equals' size="xs" />
}

const color = (elodiff, theme) => {
    if (elodiff > 0) { return theme.colors.success1 }
    if (elodiff < 0) { return theme.colors.danger1 }
    return theme.colors.black
}

const Container = styled.div`
    color: ${({ theme, elodiff }) => color(elodiff, theme)};
    fill: ${({ theme, elodiff }) => color(elodiff, theme)};

    display: flex;
    align-items: center;
    flex-direction: column-reverse;
    justify-content: center;
    width: 30px;
`

const Label = styled.div`
    font-size: 12px;
    font-weight: bold;
`

const EloDiff = ({ elodiff }) => (
    <Container elodiff={elodiff}>
        <div>{icon(elodiff)}</div>
        <Label>{elodiff}</Label>
    </Container>
)


export default EloDiff
export { color, icon }