defmodule Ccxtex.Test do
  import Ccxtex
  use ExUnit.Case, async: true
  alias Ccxtex.{Ticker, OHLCV, Market}
  doctest Ccxtex

  test "returns exchanges list" do
    {:ok, exchanges} = exchanges()
    assert "poloniex" in exchanges and "bitfinex" in exchanges
  end

  test "fetches ohlcvs from poloniex" do
    opts =
      Ccxtex.OHLCVS.Opts.make!(%{
        exchange: "poloniex",
        base: "ETH",
        quote: "USDT",
        timeframe: "1h",
        since: ~N[2018-01-01T00:00:00],
        limit: 100
      })

    {:ok, ohlcvs} = fetch_ohlcvs(opts)
    assert %OHLCV{open: _, close: _, high: _, low: _, base_volume: _, timestamp: _} = hd(ohlcvs)
  end

  test "fetches ohlcvs from bitfinex2" do
    opts =
      Ccxtex.OHLCVS.Opts.make!(%{
        exchange: "bitfinex2",
        base: "ETH",
        quote: "USDT",
        timeframe: "1h",
        since: ~N[2018-01-01T00:00:00],
        limit: 100
      })

    {:ok, ohlcvs} = fetch_ohlcvs(opts)
    assert %OHLCV{open: _, close: _, high: _, low: _, base_volume: _, timestamp: _} = hd(ohlcvs)
  end

  test "fetch bitfinex ticker" do
    exchange = "bitstamp"
    base = "ETH"
    quote = "USD"
    {:ok, ticker} = fetch_ticker(exchange, base, quote)
    assert %Ticker{ask: _, bid: _, vwap: _} = ticker
  end

  test "fetchTickers fails for bitstamp: not implemented" do
    exchange = "bitstamp"
    assert {:error, _reason} = fetch_tickers(exchange)
  end

  test "fetchTickers succeeds for poloniex" do
    exchange = "poloniex"
    {:ok, tickers} = fetch_tickers(exchange)
    assert %Ticker{high: _, low: _} = Map.get(tickers, "BTC/USDT")
  end

  test "fetch markets for bitstamp" do
    exchange = "bitstamp"
    {:ok, markets} = fetch_markets(exchange)

    assert %Market{
             active: _,
             base: _,
             base_id: _,
             id: _,
             info: _,
             limits: _,
             precision: _,
             quote: _,
             quote_id: _,
             symbol: _,
             symbol_id: _
           } = hd(markets)
  end
end
