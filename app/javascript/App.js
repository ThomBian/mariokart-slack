import React from 'react'
import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client'

import Games from './App/Games'

const client = new ApolloClient({
    uri: '/data',
    cache: new InMemoryCache()
});

const App = () => (
    <ApolloProvider client={client}>
        <Games />
    </ApolloProvider>
)

export default App