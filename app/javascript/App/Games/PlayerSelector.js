import React, { useState } from "react";
import { useApolloClient } from '@apollo/client';
import AsyncSelect from "react-select/async";

import { withMedia } from 'basics/Media'

import debounce from "utils/debounce";

import { PLAYERS } from 'utils/queries'

const PlayerSelector = ({ selectedValue, onChange, isDesktop }) => {
    const [width, setWidth] = useState(200)

    const client = useApolloClient()

    const fetchPlayers = (term, callback) => {
        if (term && term.trim().length < 3) {
            return [];
        }

        client.query({
            query: PLAYERS,
            variables: { term }
        }).then(({ data }) => callback(data ? data.players.map(({ name, id }) => ({ label: name, value: id })) : []))
    }

    const loadOptions = debounce(fetchPlayers)

    const customStyles = {
        control: (provided) => ({
            ...provided,
            width,
        }),
    }

    return (
        <AsyncSelect
            loadOptions={loadOptions}
            onChange={onChange}
            isClearable
            placeholder="Search a player"
            className="select"
            value={selectedValue}
            cacheOptions
            styles={customStyles}
            onFocus={() => isDesktop && setWidth((prev) => prev * 2)}
            onBlur={() => isDesktop && setWidth((prev) => prev / 2)}
        />
    )
}

export default withMedia(PlayerSelector)