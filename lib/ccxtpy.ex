defmodule Ccxtpy do
  use Export.Python

  @moduledoc """
  Documentation for Ccxtpy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ccxtpy.hello
      :world

  """
  def exchanges do
    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))

    res = Python.call(py, "ccxt_port", "fetch_exchanges", [])
    Poison.Parser.parse!(res)
  end

  def fetch_markets_for_exchange(exchange) do
    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))

    res = Python.call(py, "ccxt_port", "fetch_markets_for_exchange", [exchange])
    Poison.Parser.parse!(res)
  end

  def fetch_ohlcvs(exchange, symbol, timeframe, since, limit) do
    [base, quote] = String.split(symbol, "/")

    since =
      if since do
        since
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix(:millisecond)
      else
        since
      end

    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))

    res = Python.call(py, "ccxt_port", "fetch_ohlcv", [exchange, symbol, timeframe, since, limit])

    res
    |> Poison.Parser.parse!()
    |> parse_ohlcvs()
    |> Enum.map(&Map.merge(&1, %{base: base, quote: quote}))
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
