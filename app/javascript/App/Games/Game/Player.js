import React from "react";

const parseName = (name) => name.replace(/[<|>|@]/gi, '');

const Player = ({displayName, elo, ...props}) => (
    <div {...props}>
        {`${parseName(displayName)}: ${elo}`}
    </div>
)

export default Player