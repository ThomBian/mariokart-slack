import React from "react";
import styled from "styled-components";

import Stat from "./Stat";

const Container = styled.div`
    display: flex;
`

const Stats = ({ stats }) => {
    return (
        <Container>
            {stats.map(({ title, value }) => <Stat key={title} title={title} value={value} />)}
        </Container>
    )
}

export default Stats