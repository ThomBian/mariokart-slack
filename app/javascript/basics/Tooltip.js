import React from "react";
import styled from "styled-components";

import Popup from "reactjs-popup";

const Tooltip = styled(Popup)`
    // use your custom style for ".popup-overlay"  
    &-overlay {
    }  

    // use your custom style for ".popup-content"      
    &-content {
        padding: 0;
        border: none;

        background: ${({ theme }) => theme.colors.black};
        color: ${({theme}) => theme.colors.white};

        margin-right: 4px;
        box-shadow: 0px 8px 24px rgba(0, 0, 0, 0.15);
        padding: 12px;
    }

    &-arrow {
        color: ${({ theme }) => theme.colors.black};
    }
`

export default Tooltip;