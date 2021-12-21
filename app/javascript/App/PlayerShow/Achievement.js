import React from 'react';
import styled from 'styled-components';

const Container = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    & > :not(:last-child) {
        margin-bottom: 8px;
    }
`

const EmojiContainer = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 88px;
    height: 88px;
    
    font-weight: bold;
    font-size: 24px;

    border-radius: 2px;

    color: ${({ active }) => !active && 'transparent'};
    text-shadow: ${({ active, theme }) => !active && `0 0 0 ${theme.colors.default2}`}; ;

    background: ${({ theme, active }) => active ? theme.colors.primary1 : theme.colors.default1};
    border: 1px solid ${({ theme, active }) => active ? theme.colors.primary3 : theme.colors.default2};
    box-sizing: border-box;
`

const Name = styled.div`
    font-size: 10px;
    text-align: center;
    width: 100%;

    font-weight: ${({ active }) => active && 'bold'};
    color: ${({ theme, active }) => active && theme.colors.primary3};
`

const Achievement = ({ active, name, emoji }) => (
    <Container>
        <EmojiContainer active={active}>{emoji}</EmojiContainer>
        <Name active={active}>{name}</Name>
    </Container>
)

export default Achievement;