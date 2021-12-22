import React from 'react'
import useCurrentUser from 'context/CurrentUser'

import PlayerShow from './PlayerShow'

const MyProfile = () => {
    const { loading, currentUser } = useCurrentUser()
    if (loading) {
        return (<div>Loading...</div>)
    }

    if (!currentUser.authenticated) {
        window.location.replace('/')
        return null
    } else {
        const { player: { id } } = currentUser
        return (<PlayerShow id={id.toString()} />)
    }
}

export default MyProfile