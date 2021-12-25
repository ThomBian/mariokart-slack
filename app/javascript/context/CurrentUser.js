import React, { useContext, createContext, useState } from "react";
import { useQuery } from '@apollo/client'

import { CURRENT_USER } from 'utils/queries'

const CurrentUserContext = createContext({ loaded: false, loading: true, error: null, currentUser: { authenticated: false } });

const useCurrentUser = () => useContext(CurrentUserContext);

const Provider = (props) => {
    const { loading, error, data } = useQuery(CURRENT_USER);
    const [currentUser, setCurrentUser] = useState({ authenticated: false })
    const [loaded, setLoaded] = useState(false)

    if (loading) {
        return <div>Loading...</div>
    }

    if (!loading && !loaded) {
        setCurrentUser(data.currentUser)
        setLoaded(true)
    }

    return <CurrentUserContext.Provider value={{ loaded, loading, error, currentUser, setCurrentUser }} {...props} />
}

export default useCurrentUser
export { Provider }
