import React from 'react'
import styled from 'styled-components'
import { useQuery } from '@apollo/client'
import InfiniteScroll from 'react-infinite-scroll-component';

import { GAMES } from 'utils/queries'
import { cssQueries } from 'basics/Media';

import Game from './Games/Game'

const Container = styled.div`
    @media ${cssQueries.desktop} {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }

    @media ${cssQueries.mobile} {
        & > :not(:last-child) {
            margin-bottom: 8px;
        }
    }
`

const Games = () => {
    const { loading, error, data, fetchMore } = useQuery(GAMES);
    if (loading) return <p>Loading...</p>;
    if (error) return <p>Error :(</p>;

    const nodes = data.games.edges.map((edge) => edge.node);
    const pageInfo = data.games.pageInfo
    const hasNextPage = pageInfo.hasNextPage

    const handleNextPage = () => {
        if (!hasNextPage) { return }
        fetchMore({
            variables: {
                cursor: pageInfo.startCursor
            },
        })
    }

    return (
        <div>
            <h1>Games</h1>
            <InfiniteScroll
                dataLength={nodes.length} //This is important field to render the next data
                next={handleNextPage}
                hasMore={hasNextPage}
                loader={<h4>Loading...</h4>}
            >
                <Container>
                    {nodes.map(({ id, ...props }) => <Game key={id} id={id} {...props} />)}
                </Container>
            </InfiniteScroll>
        </div>
    )
}

export default Games