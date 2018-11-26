import React, { Component } from 'react'
import { Presence } from 'phoenix'

import Board from '../../components/Board'
import Instructions from '../../components/Instructions'
import PlayerStatus from '../../components/PlayerStatus'
import socket from '../../socket'

const winMessage = (winner) => {
  switch (winner) {
    case 'X':
      return 'X wins!'
    case 'O':
      return 'O wins!'
    case 'DRAW':
      return "It's a draw"
    default:
      return 'Something has gone wrong, game terminated :('
  }
}

const responseToState = (resp) => ({
  turn: resp.turn,
  over: resp.over,
  winner: resp.winner,
  squares: resp.board,
})

const Message = ({ message }) => (
  <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 5 }}>
    <span>{message}</span>
  </div>
)

class GamePage extends Component {
  constructor() {
    super()

    this.state = {
      channel: null,
      waitingForOpponent: false,
      mark: null,
      squares: Array(9).fill(null),
      turn: 'X',
      over: false,
      winner: null,
    }
  }

  componentDidMount() {
    this.connect()
  }

  connect() {
    const gameId = this.props.match.params.id
    const channel = socket.channel(`game:${gameId}`)
    let presences = {}

    const onPresenceChange = () => {
      const presencesCount = Object.keys(presences).length
      if (presencesCount < 2) {
        this.setState({ waitingForOpponent: true })
      } else {
        this.setState({ waitingForOpponent: false })
      }
    }

    channel.on('presence_state', (state) => {
      presences = Presence.syncState(presences, state)
      onPresenceChange()
    })

    channel.on('presence_diff', (diff) => {
      presences = Presence.syncDiff(presences, diff)
      onPresenceChange()
    })

    channel.on('make_move', (resp) => {
      this.setState(responseToState(resp))

      if (resp.over) channel.leave()
    })

    channel.join().receive('ok', ({ game, player }) =>
      this.setState({
        channel,
        mark: player,
        ...responseToState(game),
      }),
    )
  }

  componentWillUnmount() {
    if (this.state.channel && this.state.channel.leave) {
      this.state.channel.leave()
    }
  }

  makeMove(payload) {
    this.state.channel.push('make_move', payload).receive('ok', (resp) => {
      this.setState(responseToState(resp))
    })
  }

  handleSquareClick(i) {
    const { turn, mark, over } = this.state
    const squares = this.state.squares.slice()
    if (squares[i] || over || turn !== mark) {
      return
    }

    this.makeMove({ player: mark, position: i })
  }

  render() {
    const { winner, over, turn, mark } = this.state

    let message
    if (over) {
      message = winMessage(winner)
    } else {
      message = turn === mark ? `Your turn - ${mark}` : `${turn}'s turn`
    }

    return (
      <div>
        <Instructions />
        <Message message={message} />
        <Board
          squares={this.state.squares}
          onSquareClick={(i) => this.handleSquareClick(i)}
        />
        <PlayerStatus connected={!this.state.waitingForOpponent} />
      </div>
    )
  }
}

export default GamePage
