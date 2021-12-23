import styled from 'styled-components'

import { cssQueries } from 'basics/Media'

const Stack = styled.div`
  position: fixed;
  display: flex;
  flex-direction: column-reverse;
  z-index: 1000;

  @media ${cssQueries.desktop} {
    right: .8rem;
    bottom: 6.25rem;
    width: 25rem;
  }

  @media ${cssQueries.mobile} {
    top: 0;
    left: 0;
    width: 100%;
  }

  > :not(:last-child) {
    @media ${cssQueries.desktop} {
      margin-top: .3rem;
    }

    @media ${cssQueries.mobile} {
      border-top: solid 1px ${({ theme }) => theme.colors.default1};
    }
  }
`

export default Stack
