import React, { Component } from 'react'

import styles from './styles.css'
import socket from '../../socket'
import history from '../../utils/history'

class LobbyPage extends Component {
  constructor() {
    super()
  }

  componentDidMount() {
    this.connect()
  }

  connect() {
    this.channel = socket.channel('lobby')
  }

  startNewGame() {
    this.channel.join().receive('ok', (resp) => {
      this.channel.push('new_game').receive('ok', (resp) => {
        this.channel.leave()
        history.push(`/game/${resp.game_id}`)
      })
    })
  }

  render() {
    return (
      <div className={styles.Lobby}>
        <div className={styles.LobbyHeader}>
          <h1>Tic Tac Toe!</h1>
        </div>
        <div>
          <button className={styles.Button} onClick={() => this.startNewGame()}>
            Start new game
          </button>
        </div>
      </div>
    )
  }
}

export default LobbyPage
