defmodule Ccxtpy do
  use Export.Python

  @moduledoc """
  Documentation for Ccxtpy.
  """

  def exchanges(pid) do
    res = Python.call(pid, "ccxt_port", "fetch_exchanges", [])
    exchanges = Poison.Parser.parse!(res)
    for ex <- exchanges, into: %{} do
      AtomicMap.convert(ex, %{safe: false})
    end
  end

  def fetch_markets_for_exchange(pid, exchange) do
    res = Python.call(pid, "ccxt_port", "fetch_markets_for_exchange", [exchange])
    markets = Poison.Parser.parse!(res)
    for m <- markets, into: %{} do
      AtomicMap.convert(m, %{safe: false})
    end
  end

  def fetch_ohlcvs(pid, exchange, symbol, timeframe, since, limit) do
    [base, quote] = String.split(symbol, "/")

    since =
      if since do
        since
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix(:millisecond)
      else
        since
      end

    res = Python.call(pid, "ccxt_port", "fetch_ohlcv", [exchange, symbol, timeframe, since, limit])

    res
    |> Poison.Parser.parse!()
    |> parse_ohlcvs()
    |> Enum.map(&Map.merge(&1, %{base: base, quote: quote, exchange: exchange}))
  end

  def parse_ohlcvs(raw_ohlcvs) do
    for [unix_time_ms, open, high, low, close, volume] <- raw_ohlcvs do
      %{
        timestamp: unix_time_ms |> DateTime.from_unix!(:millisecond) |> DateTime.to_naive(),
        open: open,
        high: high,
        low: low,
        close: close,
        base_volume: volume
      }
    end
  end
end
