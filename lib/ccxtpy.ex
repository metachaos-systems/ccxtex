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
    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))
    since = since |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix(:millisecond)

    res = Python.call(py, "ccxt_port", "fetch_ohlcv", [exchange, symbol, timeframe, since, limit])
    Poison.Parser.parse!(res)
  end

end
