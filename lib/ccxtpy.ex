defmodule Ccxtpy do
  use Export.Python

  def exchanges do
    {:ok, py} = Python.start(python_path: Path.expand("priv/python"))

    Python.call(py, "ccxt_port", "exchanges", [])
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
