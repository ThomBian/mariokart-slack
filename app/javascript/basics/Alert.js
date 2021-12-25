import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'

import { cssQueries } from 'basics/Media'

const ALERT_TYPES = {
    success: 'success',
    notice: 'notice',
    danger: 'danger',
    error: 'error',
    alert: 'alert',
    warning: 'warning',
}

const backgroundColor = (type, theme) => {
    switch (type) {
        case ALERT_TYPES.success:
        case ALERT_TYPES.notice:
            return theme.colors.success3
        case ALERT_TYPES.error:
        case ALERT_TYPES.alert:
        case ALERT_TYPES.danger:
        case ALERT_TYPES.warning:
            return theme.colors.danger2
        default:
            return theme.colors.success1
    }
}

const Body = styled.div`
  display: flex;
  align-items: center;
  background-color: ${({ type, theme }) => backgroundColor(type, theme)};
  color: ${({ theme }) => theme.colors.white};
  box-sizing: border-box;
  padding: 15px;
  font-weight: 500;
  border-radius: 3px;

  @media ${cssQueries.mobile} {
    max-width: 100vw;
    border-radius: 0;
    min-height: 70px;
  }
`

const Text = styled.div`
  flex-grow: 1;
  font-size: 16px;
  white-space: pre-wrap;
`

const Alert = ({ text, type, ...props }) => (
    <Body type={type} {...props}>
        <Text>{text}</Text>
    </Body>
)

Alert.propTypes = {
    text: PropTypes.node.isRequired,
    type: PropTypes.oneOf(Object.values(ALERT_TYPES)).isRequired,
}

export default Alert
export { ALERT_TYPES }
