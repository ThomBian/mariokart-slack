import React from "react";
import styled from "styled-components";

import CoinIcon from 'img/coin.svg'
import CoinsIcon from 'img/coins.svg'

import Button from "basics/Button";

const Container = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 12px;

    background: ${({ theme }) => theme.colors.white};
    border: 1px solid ${({ theme }) => theme.colors.default1};
    box-sizing: border-box;
    border-radius: 4px;

    & > :not(:last-child) {
        margin-bottom: 12px;
    }
`

const Header = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 0px;
`

const Title = styled.div`
    font-weight: bold;
    font-size: 18px;
    line-height: 22px;

    /* identical to box height */
    text-align: center;

    color: ${({ theme }) => theme.colors.primary6};
`

const CoinContainer = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;

    & > :not(:last-child) {
        margin-right: 4px;
    }
`

const Value = styled.div`
    font-weight: bold;
    font-size: 18px;
    line-height: 22px;
`

const ValueImgContainer = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
`

const ValueImg = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;

    font-weight: bold;
    font-size: 18px;
    line-height: 22px;
`

const PriceButton = styled(Button)`
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;

    background: ${({ theme }) => theme.colors.primary5};
    border-radius: 4px;

    width: 100%;
    cursor: pointer;
`

const displayPrice = (price) => price == 0 ? 'Free' : `${price}€`

const AddMoneyOption = ({ title, value, price, disabled, playerId, onClick, ...props }) => (
    <Container {...props}>
        <Header>
            <Title>{title}</Title>
            <CoinContainer>
                <CoinIcon />
                <Value>{value}</Value>
            </CoinContainer>
        </Header>

        <ValueImgContainer>
            <CoinsIcon />
            <ValueImg>{`x${value / 5}`}</ValueImg>
        </ValueImgContainer>

        <PriceButton onClick={onClick} disabled={disabled}>
            {displayPrice(price)}
        </PriceButton>
    </Container>
)

export default AddMoneyOption;