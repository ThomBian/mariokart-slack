import React, { useState } from "react";
import styled from "styled-components";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Link } from "react-router-dom";
import Popup from 'reactjs-popup';

import Tabs from "./Tabs";
import Logo from 'img/mario.svg'

const Container = styled.div`
    display: flex;
    align-items: center;
    justify-content: space-between;

    position: fixed;
    left: 0;
    right: 0;
    top: 0;

    background: ${({ theme }) => theme.colors.white};
    border-bottom: 1px solid ${({ theme }) => theme.colors.default1};

    padding: 4px 24px;

    z-index: 999;
`
const overlayStyle = { background: 'rgba(0,0,0,0.5)' };
const contentStyle = { background: '#fff', position: 'fixed', top: '0', right: '0', bottom: '0', width: "250px", padding: "16px" };
const Mobile = () => {
    const [open, setOpen] = useState(false);
    const closeModal = () => setOpen(false);
    return (
        <Container>
            <div><Link to="/"><Logo /></Link></div>
            <div>
                <FontAwesomeIcon icon="bars" size="lg" onClick={() => setOpen(true)} />
                <Popup
                    open={open} closeOnDocumentClick onClose={closeModal}
                    modal
                    closeOnDocumentClick
                    overlayStyle={overlayStyle}
                    contentStyle={contentStyle}
                >
                    <Tabs closeModal={closeModal} />
                </Popup>
            </div>
        </Container>
    )
}

export default Mobile;