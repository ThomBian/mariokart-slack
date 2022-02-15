import React from "react";
import styled from "styled-components";

import { cssQueries } from "basics/Media";
import Stat from "./Stat";

const Container = styled.div`
    display: flex;
    justify-content: space-between;
    width: 100%;

    @media ${cssQueries.mobile} {
        justify-content: space-around;
    }
`

const Stats = ({ stats }) => {
    return (
        <Container>
            {stats.map(({ title, value }) => <Stat key={title} title={title} value={value} />)}
        </Container>
    )
}

export default Stats