import React from "react";
import { ResponsiveLine } from '@nivo/line'
import theme from 'theme.js'

const EloHistory = ({ points }) => {
    const nivoPoints = points.map(({ x, y }) => ({ "x": x, "y": y }))
    return (
        <ResponsiveLine
            data={[{ id: 'elo', data: nivoPoints }]}
            margin={{ top: 50, right: 50, bottom: 68, left: 50 }}
            xScale={{ type: 'point' }}
            yScale={{ type: 'linear', min: 'auto', max: 'auto', stacked: true, reverse: false }}
            yFormat=">-.0d"
            curve="cardinal"
            axisTop={null}
            axisRight={null}
            axisBottom={{
                orient: 'bottom',
                tickSize: 5,
                tickPadding: 5,
                tickRotation: 90,
                legendOffset: 41,
                legendPosition: 'middle'
            }}
            axisLeft={{
                orient: 'left',
                tickSize: 5,
                tickPadding: 5,
                tickRotation: 0,
                legend: 'elo',
                legendOffset: -40,
                legendPosition: 'middle'
            }}
            pointSize={6}
            colors={[theme.colors.primary3]}
            pointBorderWidth={2}
            pointLabelYOffset={-12}
            useMesh={true}
            legends={[]}
            enablePointLabel
        />
    )
}

export default EloHistory