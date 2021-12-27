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
        const { player } = currentUser
        if (!player) { return 'You have never played a game or we could not find the player' }
        return (<PlayerShow id={player.id.toString()} />)
    }
}

export default MyProfile