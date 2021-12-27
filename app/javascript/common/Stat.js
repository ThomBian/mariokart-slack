import React from "react";
import styled from "styled-components";

const StatContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 50px;

    & > :not(:last-child) {
        margin-bottom: 4px;
    }
`
const Title = styled.div`
    font-weight: bold;
    font-size: 14px;
`

const Value = styled.div`
    font-size: 18px;
    line-height: 18px;
`

const Stat = ({ title, value }) => (
    <StatContainer>
        <Title>{title}</Title>
        <Value>{value}</Value>
    </StatContainer>
)

export default Stat