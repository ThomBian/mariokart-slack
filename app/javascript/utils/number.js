const round = (num) => Math.round((num + Number.EPSILON) * 100) / 100

const format = (num) => {
    if (num < 1000) { return round(num) }
    const thousands = num / 1000
    return `${round(thousands)}k`
}


export { round, format }