const ccxt = require("ccxt")

async function fetchTrades({ exchange, base, quote, since }) {
  const symbolString = `${base}/${quote}`
  const sinceUnix = new Date(since).getTime()
  return await new ccxt[exchange].fetchTrades(symbolString, sinceUnix)
}

const exchanges = async () => ccxt.exchanges

async function fetchOhlcvs({exchange, base, quote, period, since, limit }) {
  const symbol = `${base}/${quote}`
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchOHLCV(symbol, period, since, limit)

}

async function fetchTicker({exchange, symbol}) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchTicker(symbol)
}

async function fetchTickers(exchange, symbols, params) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchTickers(symbols, params)
}

async function fetchMarkets(exchange) {
  const _exchange = new ccxt[exchange]()
  return await _exchange.fetchMarkets()
}

async function fetchMarketsForExchange(exchange_id) {
  const exchange = new ccxt[exchange_id]()
  return await exchange.loadMarkets()
}


module.exports = {
  fetchTrades,
  exchanges,
  fetchMarketsForExchange,
  fetchOhlcvs,
  fetchTicker,
  fetchTickers,
  fetchMarkets
}
