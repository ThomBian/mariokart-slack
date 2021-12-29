import styled from "styled-components";
import Popup from "reactjs-popup";

const Modal = styled(Popup)`
    // use your custom style for ".popup-overlay"  
    &-overlay {
    }  
    
    // use your custom style for ".popup-content"      
    &-content {
        width: 300px;
        border-radius: 2px;
        padding: 0;
        border: none;

        background: ${({ theme }) => theme.colors.white};

        margin-right: 4px;
        box-shadow: 0px 8px 24px rgba(0, 0, 0, 0.15);
    }
`

export default Modal