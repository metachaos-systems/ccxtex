const ccxt = require("ccxt")

async function fetchTrades({ exchange, base, quote, since }) {
  const symbolString = `${base}/${quote}`
  const sinceUnix = new Date(since).getTime()
  await new ccxt[exchange].fetchTrades(symbolString, sinceUnix)
}

const exchanges = async () => ccxt.exchanges

async function fetchOHLCV({ exchange_id, symbol, period, since, limit }) {
  const exchange = new ccxt[exchange_id]()
  await exchange.fetchOHLCV(symbol, period, since, limit)
}

async function fetchMarketsForExchange(exchange_id) {
  const exchange = new ccxt[exchange_id]()
  await exchange.loadMarkets()
}

module.exports = {
  fetchTrades,
  exchanges,
  fetchMarketsForExchange,
  fetchOHLCV,
}
