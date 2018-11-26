import React from 'react'

import styles from './styles.css'

const iconConnected = () => (
  <div className={[styles.Icon, styles.IconConnected].join(' ')} />
)
const iconDisconnected = () => (
  <div className={[styles.Icon, styles.IconDisconnected].join(' ')} />
)

export default ({ connected }) => {
  return (
    <div className={styles.Wrapper}>
      {connected === true ? iconConnected() : iconDisconnected()}
      <span>
        {connected === true ? 'Opponent connected' : 'Opponent not connected'}
      </span>
    </div>
  )
}
