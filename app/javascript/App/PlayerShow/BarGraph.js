import React from 'react'
import { ResponsiveBar } from '@nivo/bar'
import theme from 'theme.js'

const BarGraph = ({ data }) => (
    <ResponsiveBar
        data={data.series}
        keys={data.keys}
        indexBy={data.indexBy}
        margin={{ top: 30, right: 50, bottom: 30, left: 50 }}
        padding={0.3}
        valueScale={{ type: 'linear' }}
        indexScale={{ type: 'band', round: true }}
        colors={[theme.colors.primary3]}
        axisTop={null}
        axisRight={null}
        axisBottom={{
            orient: 'bottom',
            tickSize: 5,
            tickPadding: 5,
            tickRotation: 0,
            legendOffset: 41,
            legendPosition: 'middle'
        }}
        axisLeft={{
            tickSize: 5,
            tickPadding: 5,
            tickRotation: 0,
            legend: data.id,
            legendPosition: 'middle',
            legendOffset: -40
        }}
        labelSkipWidth={12}
        labelSkipHeight={12}
        legends={[]}
    />
)

export default BarGraph;