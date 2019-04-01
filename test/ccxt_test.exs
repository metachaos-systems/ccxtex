defmodule Ccxtex.Test do
  import Ccxtex
  use ExUnit.Case, async: true
  alias Ccxtex.{Ticker, OHLCV, Market, OhlcvOpts}
  doctest Ccxtex

  @default_ohlcv_opts %OhlcvOpts{
    exchange: "binance",
    base: "BTC",
    quote: "USDT",
    timeframe: "1m",
    since: ~N[2018-01-01T00:00:00],
    limit: 100
  }

  test "returns exchanges list" do
    {:ok, exchanges} = exchanges()
    assert "poloniex" in exchanges and "bitfinex" in exchanges
  end

  test "fetches ohlcvs from poloniex" do
    {:ok, ohlcvs} = fetch_ohlcvs(%{@default_ohlcv_opts | exchange: "poloniex", timeframe: "5m"})
    assert %OHLCV{open: _, close: _, high: _, low: _, base_volume: _, timestamp: _} = hd(ohlcvs)
  end

  test "fetches ohlcvs from okex" do
    # okex fetchOHLCV counts "limit" candles from current time backwards, therefore the "limit" argument for okex is disabled.
    opts = %{@default_ohlcv_opts | exchange: "okex"} |> Map.drop([:limit])
    {:ok, ohlcvs} = fetch_ohlcvs(opts)
    assert %OHLCV{open: _, close: _, high: _, low: _, base_volume: _, timestamp: _} = hd(ohlcvs)
  end

  test "fetches ohlcvs from bitfinex2" do
    {:ok, ohlcvs} = fetch_ohlcvs(@default_ohlcv_opts)

    assert %OHLCV{open: _, close: _, high: _, low: _, base_volume: _, timestamp: _} =
             hd(tl(ohlcvs))
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
    assert {:error, reason} = fetch_tickers(exchange)
  end

  test "fetchTickers succeeds for poloniex" do
    exchange = "poloniex"
    {:ok, tickers} = fetch_tickers(exchange)
    assert %Ticker{high: _, low: _} = Map.get(tickers, "BTC/USDT")
  end

  test "fetch markets for kraken" do
    exchange = "kraken"
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

  test "fetch markets for bitstamp" do
    exchange = "binance"
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
