const round = (num) => Math.round((num + Number.EPSILON) * 100) / 100

const SYMBOLS = ['', 'k', 'm', 'M']
const format = (num) => {
    let formatted = num
    let symbolIdx = 0
    while (formatted >= 1000) {
        formatted = formatted / 1000
        symbolIdx++
    }
    const symbol = SYMBOLS[symbolIdx]
    const final = round(formatted)
    return `${final}${symbol}`
}


export { round, format }