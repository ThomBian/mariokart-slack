import React from "react"

import Player from './Game/Player'

const Game = ({ id, status, players, ...props }) => (
    <div {...props}>
        <div>{`Game #${id}`}</div>
        <div>{status}</div>
        <div>
            {players.map((player) => <Player {...player} /> )}
        </div>
    </div>
)

export default Game