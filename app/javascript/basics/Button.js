import React from "react";
import styled from "styled-components";

import { cssQueries } from 'basics/Media';

const StyledButton = styled.button`
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: flex-start;
    padding: 8px 12px;

    background: ${({ theme }) => theme.colors.primary3};
    border-radius: 2px;
    
    font-weight: 500;
    font-size: 16px;
    line-height: 16px;
    color: ${({ theme }) => theme.colors.white};

    &:hover {
        background: ${({ theme }) => theme.colors.primary4};
    }
    
    &:disabled {
        cursor: not-allowed;
        pointer-events: all !important;
        background: ${({ theme }) => theme.colors.primary2}; 
    }

    @media ${cssQueries.mobile} {
        width: 100%;
        padding: 12px;
    }
`

const Button = ({ children, ...props }) => (
    <StyledButton {...props}>
        {children}
    </StyledButton>
)

export default Button;