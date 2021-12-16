import React from "react";

import Media from 'basics/Media'

import Desktop from "./Navbar/Desktop";
import Mobile from "./Navbar/Mobile";

const Navbar = () => (
    <Media
        desktop={() => <Desktop />}
        mobile={() => <Mobile />}
    />
)

export default Navbar