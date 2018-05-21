defmodule CcxtpyTest do
  import Ccxtpy
  use ExUnit.Case
  doctest Ccxtpy

  test "greets the world" do
    assert Ccxtpy.hello() == :world
  end

  test "fetches ohlcvs from bitfinex2" do
    exchange = "bitfinex2"
    symbol = "ETH/USDT"
    timeframe = "1h"
    since = ~N[2018-01-01T00:00:00]
    limit = 1000
    assert fetch_ohlcvs(exchange, symbol, timeframe, since, limit) == []
  end
end
