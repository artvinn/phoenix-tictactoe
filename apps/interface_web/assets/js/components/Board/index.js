import React, { Component } from 'react'

import styles from './style.css'

const Square = (props) => (
  <div className={styles.Square} onClick={props.onClick}>
    {props.value}
  </div>
)

export default class Board extends Component {
  renderSquare(i) {
    return (
      <Square
        value={this.props.squares[i]}
        onClick={() => this.props.onSquareClick(i)}
      />
    )
  }

  render() {
    return (
      <div className={styles.Board}>
        {this.renderSquare(0)}
        {this.renderSquare(1)}
        {this.renderSquare(2)}
        {this.renderSquare(3)}
        {this.renderSquare(4)}
        {this.renderSquare(5)}
        {this.renderSquare(6)}
        {this.renderSquare(7)}
        {this.renderSquare(8)}
      </div>
    )
  }
}
