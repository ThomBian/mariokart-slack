import React, { useState, useContext, createContext } from 'react';

const FlashAlertsContext = createContext({
    alerts: [],
    add: () => null,
    remove: () => null,
})

const useFlashAlerts = () => useContext(FlashAlertsContext)

const getRandomKey = () => `_${Math.random().toString(36).substr(2, 9)}`

const Provider = ({ value, ...props }) => {
    const [alerts, setAlerts] = useState([])

    const remove = (alertId) => setAlerts((prevAlerts) => ([
        ...prevAlerts.filter(({ id }) => id !== alertId),
    ]))

    const add = ({ text, type, autoDismiss = 5000 }) => {
        const id = getRandomKey()
        setAlerts((prevAlerts) => [...prevAlerts, { id, text, type }])
        setTimeout(() => { remove(id) }, autoDismiss)
        return id
    }

    const providedValues = {
        alerts,
        add,
        remove,
    }

    return <FlashAlertsContext.Provider value={providedValues} {...props} />
}

export default useFlashAlerts
export { Provider }
