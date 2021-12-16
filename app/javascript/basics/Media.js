import React from 'react'
import ReactMedia from 'react-media'

// Component to allow displaying a different component for each media
// Usage:
// <Media
//    desktop={() => <div>desktop view</div>}
//    mobile={() => <div>Mobile view</div>
// </Media>

const breakpoints = {
  desktop: 960,
}

const cssQueries = {
  desktop: `(min-width: ${breakpoints.desktop}px)`,
  mobile: `(max-width: ${breakpoints.desktop - 1}px)`,
}

const Media = ({ desktop, mobile }) => (
  <ReactMedia query={cssQueries.desktop}>
    {
      (isDesktop) => (isDesktop ? desktop() : mobile())
    }
  </ReactMedia>
)

const withMedia = (Component) => ({ ...props }) => (
  <Media
    desktop={() => <Component isDesktop isMobile={false} {...props} />}
    mobile={() => <Component isDesktop={false} isMobile {...props} />}
  />
)

export { cssQueries, withMedia }
export default Media
