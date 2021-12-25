import React from 'react'
import styled from 'styled-components';
import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client'
import { ThemeProvider } from 'styled-components'
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'

import { cssQueries } from 'basics/Media';
import FlashAlerts from 'basics/FlashAlerts'
import ErrorBoundary from 'common/ErrorBoundary';

import { Provider as CurrentUserProvider } from 'context/CurrentUser'
import { Provider as FlashAlertProvider } from 'context/FlashAlerts'

import theme from './theme'

import Navbar from './App/Navbar';
import Games from './App/Games'
import Ranking from './App/Ranking';
import PlayerShow from './App/PlayerShow';
import Money from './App/Money';
import MyProfile from './App/MyProfile'
import LoginSuccess from './App/LoginSuccess';

const client = new ApolloClient({
    uri: '/data',
    cache: new InMemoryCache()
});

library.add(fas)

const Container = styled.div`
    display: flex;
    
    @media ${cssQueries.desktop} {
        flex-direction: row;
    }

    @media ${cssQueries.mobile} {
        flex-direction: column;
    }

    height: 100%;
`

const ContentContainer = styled.div`
    width: 100%;
    @media ${cssQueries.desktop} {
        margin-left: 220px;
    }

    @media ${cssQueries.mobile} {
        margin-top: 50px;
    }
`

const App = () => (
    <ErrorBoundary>
        <ApolloProvider client={client}>
            <ThemeProvider theme={theme}>
                <BrowserRouter>

                    <CurrentUserProvider>
                        <FlashAlertProvider>
                            <Container>
                                <Navbar />

                                <ContentContainer>
                                    <Routes>
                                        <Route path="/" element={<Navigate to="games" />} />
                                        <Route path="games" element={<Games />} />
                                        <Route path="ranking" element={<Ranking />} />
                                        <Route path="player/:id" element={<PlayerShow />} />
                                        <Route path="money" element={<Money />} />
                                        <Route path="me" element={<MyProfile />} />
                                        <Route path="login-success" element={<LoginSuccess />} />
                                    </Routes>
                                </ContentContainer>

                                <FlashAlerts />
                            </Container>
                        </FlashAlertProvider>
                    </CurrentUserProvider>

                </BrowserRouter>
            </ThemeProvider>
        </ApolloProvider>
    </ErrorBoundary >
)

export default App