import React from 'react'
import Alert from 'basics/Alert'

import useFlashAlerts from 'context/FlashAlerts'
import Stack from './FlashAlerts/Stack'

const FlashAlerts = () => {
  const { alerts } = useFlashAlerts()

  return (
    <Stack>
      {alerts.map(({ text, id, type }) => (
        <Alert key={id} text={text} type={type} />
      ))}
    </Stack>
  )
}

export default FlashAlerts