# Ccxtex

Ccxtex package provides easy (presently somewhat brittle) Elixir/Erlang interoperability with JS version of [ccxt library](https://github.com/ccxt/ccxt). Ccxt provides an unified API for querying for historical/recent data and trading operations for multiple cryptocurrency exchanges including GDAX, Bitfinex, Poloniex, Binance and others.

## Installation

### Elixir

```elixir
def deps do
  [
    {:ccxtex, "~> 0.3.0"}
  ]
end
```

### JS

You need nodejs (>= 10) installed to run Ccxtex.

## Status and roadmap

Ccxtex is usable, but is under active development. Some exchanges do not support all methods/require CORS/have other esoteric requirements. Please consult [ccxt documentation](https://github.com/ccxt/ccxt) for more details.

### Public APIs in progress

- [x] fetch_ticker
- [x] fetch_tickers
- [x] fetch_ohlcv
- [x] fetch_exchanges
- [x] fetch_markets
- [ ] fetch_trades
- [ ] fetch_order_book
- [ ] fetch_l2_order_book

### Developer experience improvements

- [x] unified public API call option structs
- [x] investigate alternative parallelism/concurrency implementation
- [ ] improve general usability of library

### Private APIs implementation and authentication are under consideration

### Exchanges

Usage:

`exchanges = exchanges()`


Return value example:

```
[
...
%{
has: %{
  cancel_order: true,
  cancel_orders: false,
  cors: false,
  create_deposit_address: true,
  create_limit_order: true,
  create_market_order: false,
  create_order: true,
  deposit: false,
  edit_order: true,
  fetch_balance: true,
  fetch_closed_orders: "emulated",
  fetch_currencies: true,
  fetch_deposit_address: true,
  fetch_funding_fees: false,
  fetch_l2_order_book: true,
  fetch_markets: true,
  fetch_my_trades: true,
  fetch_ohlcv: true,
  fetch_open_orders: true,
  fetch_order: "emulated",
  fetch_order_book: true,
  fetch_order_books: false,
  fetch_orders: "emulated",
  fetch_ticker: true,
  fetch_tickers: true,
  fetch_trades: true,
  fetch_trading_fees: true,
  private_api: true,
  public_api: true,
  withdraw: true
},
id: "poloniex",
timeout: 10000
}
]
```


### Fetch ticker and fetch tickers

`fetch_ticker` returns a ticker for a given exchange, base and quote symbols, while `fetch_tickers(exchange)` will return all tickers for a given exchange

```
exchange = "bitstamp"
base = "ETH"
quote = "USD"
ticker = fetch_ticker(exchange, base, quote)
```

Return value example:
```
%Ccxtex.Ticker{
ask: 577.35,
ask_volume: nil,
average: nil,
base_volume: 73309.52075575,
bid: 576.8,
bid_volume: nil,
change: nil,
close: 577.35,
datetime: "2018-05-24T14:06:09.000Z",
high: 619.95,
info: %{
  ask: "577.35",
  bid: "576.80",
  high: "619.95",
  last: "577.35",
  low: "549.28",
  open: "578.40",
  timestamp: "1527170769",
  volume: "73309.52075575",
  vwap: "582.86"
},
last: 577.35,
low: 549.28,
open: 578.4,
percentage: nil,
previous_close: nil,
quote_volume: 42729187.26769644,
pair_symbol: "ETH/USD",
timestamp: 1527170769000,
vwap: 582.86
}
```

### Fetch OHLCV

Fetches a list of ohlcv data, takes OHLCVS.Opts argument

```
opts =
  Ccxtex.OHLCVS.Opts.make!(%{
    exchange: "poloniex",
    base: "ETH",
    quote: "USDT",
    timeframe: "1h",
    since: ~N[2018-01-01T00:00:00],
    limit: 100
  })
ohlcvs = fetch_ohlcvs(opts)
```

Return value example:
```
%Ccxtex.OHLCV{
base: "ETH",
base_volume: 4234.62695691,
close: 731.16,
exchange: "bitfinex2",
high: 737.07,
low: 726,
open: 736.77,
quote: "USDT",
timestamp: ~N[2018-01-01 00:00:00.000]
}
```


# Fetch markets

Fetches markets for a given exchange

Example:

`fetch_markets("poloniex")`

Response example:

```
[
...
%Ccxtex.Market{
  active: true,
  base: "ETH",
  base_id: "eth",
  id: "etheur",
  info: %{
    "base_decimals" => 8,
    "counter_decimals" => 2,
    "description" => "Ether / Euro",
    "minimum_order" => "5.0 EUR",
    "name" => "ETH/EUR",
    "trading" => "Enabled",
    "url_symbol" => "etheur"
  },
  limits: %{
    "amount" => %{"min" => 1.0e-8},
    "cost" => %{"min" => 5},
    "price" => %{"min" => 0.01}
  },
  precision: %{"amount" => 8, "price" => 2},
  quote: "EUR",
  quote_id: "eur",
  symbol: "ETH/EUR",
  symbol_id: "eth_eur"
}
...
]
```
