import React, { useEffect } from "react";
import { Navigate } from "react-router-dom";

import useCurrentUser from 'context/CurrentUser';
import useFlashAlerts from 'context/FlashAlerts';

import { ALERT_TYPES } from 'basics/Alert'

const LoginSuccess = () => {
    const { loaded, currentUser } = useCurrentUser()
    const { add } = useFlashAlerts()

    console.log({ loaded })
    useEffect(() => {
        console.log({ loaded, currentUser })
        if (loaded && currentUser && currentUser.authenticated) {
            add({ type: ALERT_TYPES.success, text: 'Login with success!' })
        }
    }, [loaded])


    if (!loaded || !currentUser || currentUser && !currentUser.authenticated) { return null }
    return <Navigate to="/" />

}

export default LoginSuccess;