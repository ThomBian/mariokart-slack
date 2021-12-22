import React from 'react';

class ErrorBoundary extends React.Component {
    state = { hasError: false }
  
    static getDerivedStateFromError() {
      return { hasError: true }
    }

  
    render() {
      const { hasError } = this.state
      const { children } = this.props
      return hasError ? <div>Something went wrong...</div> : children
    }
  }
  
  export default ErrorBoundary
  