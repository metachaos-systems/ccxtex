defmodule Ccxtpy do
  use Export.Python

  def exchanges do
    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))

    Python.call(py, "ccxt_port", "exchanges", [])
  end

  def fetch_markets_for_exchange(exchange) do
    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))

    res = Python.call(py, "ccxt_port", "fetch_markets_for_exchange", [exchange])
    Poison.Parser.parse!(res)
  end

  @moduledoc """
  Documentation for Ccxtpy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ccxtpy.hello
      :world

  """
  def hello do
    :world
  end
end
