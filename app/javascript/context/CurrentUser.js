import React, { useContext, createContext } from "react";
import { useQuery } from '@apollo/client'

import { CURRENT_USER } from 'utils/queries'

const CurrentUserContext = createContext({ loading: true, error: null, currentUser: { authenticated: false } });

const useCurrentUser = () => useContext(CurrentUserContext);

const Provider = (props) => {
    const { loading, error, data } = useQuery(CURRENT_USER);

    const currentUser = !loading && !error && data.currentUser || { authenticated: false }

    return <CurrentUserContext.Provider value={{ loading, error, currentUser }} {...props} />
}

export default useCurrentUser
export {
    Provider
}
