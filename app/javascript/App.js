import React from 'react'
import styled from 'styled-components';
import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client'
import { ThemeProvider } from 'styled-components'
import { BrowserRouter, Routes, Route } from "react-router-dom";

import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'

import theme from './theme'

import Navbar from './App/Navbar';

import Games from './App/Games'
import Ranking from './App/Ranking';

const client = new ApolloClient({
    uri: '/data',
    cache: new InMemoryCache()
});

library.add(fas)

const Container = styled.div`
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    padding: 0px;
`

const NavbarContainer = styled.div`
    position: fixed;
    width: 200px;
    height: 100%; 
    z-index: 1; 
    top: 0; 
    left: 0;
    padding: 50px 16px 16px;
`

const ContentContainer = styled.div`
    width: 100%;
    margin-left: 220px;
`

const App = () => (
    <ApolloProvider client={client}>
        <ThemeProvider theme={theme}>
            <BrowserRouter>
                <Container>
                    <NavbarContainer>
                        <Navbar />
                    </NavbarContainer>

                    <ContentContainer>
                        <Routes>
                            <Route path="/" element={<Games />} />
                            <Route path="ranking" element={<Ranking />} />
                        </Routes>
                    </ContentContainer>
                </Container>
            </BrowserRouter>
        </ThemeProvider>
    </ApolloProvider>
)

export default App