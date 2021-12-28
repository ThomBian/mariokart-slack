import { InMemoryCache } from "@apollo/client";
import { relayStylePagination } from "@apollo/client/utilities";

const cache = new InMemoryCache({
    typePolicies: {
        Query: {
            fields: {
                games: {
                    keyArgs: false,
                    read: (existing) => {
                        if (!existing) { return }

                        return {
                            totalCount: existing.totalCount,
                            edges: existing.edges,
                            pageInfo: existing.pageInfo
                        }
                    },
                    merge: (existing = makeEmptyData(), incoming) => {
                        return {
                            totalCount: incoming.totalCount,
                            edges: [...existing.edges, ...incoming.edges],
                            pageInfo: incoming.pageInfo
                        }
                    }
                }
            },
        },
    },
})


const makeEmptyData = () => ({
    totalCount: 0,
    edges: [],
    pageInfo: {
        hasPreviousPage: false,
        hasNextPage: true,
        startCursor: "",
    }
})

export default cache;