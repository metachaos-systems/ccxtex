defmodule CcxtexTest do
  import Ccxtex
  use ExUnit.Case, async: true
  doctest Ccxtex

  test "fetches ohlcvs from bitfinex2" do
    exchange = "bitfinex2"
    symbol = "ETH/USDT"
    timeframe = "1h"
    since = ~N[2018-01-01T00:00:00]
    limit = 1000
    {:ok, ohlcvs} = fetch_ohlcvs(exchange, symbol, timeframe, since, limit)
    assert %{base: _, high: _, base_volume: _} = hd(ohlcvs)
  end

  test "fetches ohlcvs from poloniex" do
    exchange = "poloniex"
    symbol = "ETH/USDT"
    timeframe = "1h"
    since = ~N[2018-01-01T00:00:00]
    limit = 1000
    {:ok, ohlcvs} = fetch_ohlcvs(exchange, symbol, timeframe, since, limit)
    assert %{base: _, high: _, base_volume: _} = hd(ohlcvs)
  end

  test "fetches ohlcvs without since or limit args" do
    exchange = "kuna"
    symbol = "BTC/UAH"
    timeframe = "1h"
    {:ok, ohlcvs} = fetch_ohlcvs(exchange, symbol, timeframe, nil, nil)
    assert %{base: _, high: _, base_volume: _} = hd(ohlcvs)
  end

  test "fetches exchanges list" do
    {:ok, exchanges} = fetch_exchanges()
    assert %{has: _, id: _, timeout: _} = exchanges[:poloniex]
  end

  test "fetch bitfinex ticker" do
    exchange = "bitstamp"
    symbol = "ETH/USD"
    {:ok, ticker} = fetch_ticker(exchange, symbol)
    assert %{ask: _, bid: _, vwap: _} = ticker
  end
end
