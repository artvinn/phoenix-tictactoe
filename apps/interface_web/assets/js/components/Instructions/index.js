import React, { Component } from 'react'

import styles from './styles.css'

export default class Instructions extends Component {
  handleFocus(event) {
    event.target.select()
    document.execCommand('copy')
  }

  render() {
    return (
      <div className={styles.Instructions}>
        <span>Share this link with your opponent</span>
        <input
          defaultValue={window.location.href}
          onFocus={(e) => this.handleFocus(e)}
        />
      </div>
    )
  }
}
