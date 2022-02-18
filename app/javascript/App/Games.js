import React, { useState } from 'react'
import styled from 'styled-components'
import { useQuery, NetworkStatus } from '@apollo/client'
import InfiniteScroll from 'react-infinite-scroll-component';

import { GAMES } from 'utils/queries'
import { cssQueries } from 'basics/Media';

import Game from './Games/Game'
import PlayerSelector from './Games/PlayerSelector';

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

const Header = styled.div`
    display: flex;
    align-items: center;
    justify-content: space-between;
`

const Games = () => {
    const { loading, error, data, fetchMore, refetch, networkStatus } = useQuery(GAMES);
    const [player, setPlayer] = useState()

    if (loading || networkStatus == NetworkStatus.refetch) return <p>Loading...</p>;
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

    const onPlayerSelected = (option) => {
        setPlayer(option)
        refetch({ playerId: option && option.value })
    }

    return (
        <div>
            <Header>
                <h1>Games</h1>
                <PlayerSelector onChange={onPlayerSelected} selectedValue={player} />
            </Header>
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