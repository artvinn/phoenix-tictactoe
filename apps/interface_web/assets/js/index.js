import React from 'react'
import ReactDOM from 'react-dom'
import { Router, Route } from 'react-router-dom'

import './global.css'
import history from './utils/history'
import LobbyPage from './pages/Lobby'
import GamePage from './pages/Game'

ReactDOM.render(
  <Router history={history}>
    <div style={{ height: '100%' }}>
      <Route exact path="/" component={LobbyPage} />
      <Route path="/game/:id" component={GamePage} />
    </div>
  </Router>,
  document.getElementById('app'),
)
