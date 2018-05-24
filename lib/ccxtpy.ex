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

  def fetch_ticker(pid, exchange, symbol) do
    res = Python.call(pid, "ccxt_port", "fetch_ticker", [exchange, symbol])
    res
    |> Poison.Parser.parse!()
    |> AtomicMap.convert(%{safe: false})
  end

  def fetch_ohlcvs(pid, exchange, symbol, timeframe, since \\ nil, limit \\ nil) do
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
        open: parse_float(open),
        high: parse_float(high),
        low: parse_float(low),
        close: parse_float(close),
        base_volume: parse_float(volume)
      }
    end
  end

  def parse_float(term) when is_binary(term) do
    {float, _} = Float.parse(term)
    float
  end

  def parse_float(term) when is_float(term), do: term
  def parse_float(term) when is_integer(term), do: term
  def parse_float(nil), do: nil
end
