defmodule Ccxtpy do
  use Export.Python

  @moduledoc """
  Ccxtpy main module
  """

  def fetch_exchanges(pid) do
    call_default(pid, "fetch_exchanges")
    |> convert_keys_to_atoms()
  end

  def fetch_markets_for_exchange(pid, exchange) do
    call_default(pid, "fetch_markets_for_exchange", [exchange])
    |> convert_keys_to_atoms()
  end

  def fetch_ticker(pid, exchange, symbol) do
    call_default(pid, "fetch_ticker", [exchange, symbol])
    |> convert_keys_to_atoms()
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

    res = call_default(pid, "fetch_ohlcv", [exchange, symbol, timeframe, since, limit])

    res
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

  def call_default(pid, fn_name, args \\ []) do
    res = Python.call(pid, "ccxt_port", fn_name, args)
    Poison.Parser.parse!(res)
  end

  def convert_keys_to_atoms(x) do
    AtomicMap.convert(x, %{safe: false})
  end

  def parse_float(term) when is_binary(term) do
    {float, _} = Float.parse(term)
    float
  end

  def parse_float(term) when is_float(term), do: term
  def parse_float(term) when is_integer(term), do: term
  def parse_float(nil), do: nil
end
