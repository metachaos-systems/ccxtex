defmodule Ccxtex.Utils do
  def parse_ohlcvs(raw_ohlcvs) do
    for [unix_time_ms, open, high, low, close, volume] <- raw_ohlcvs do
      %{
        timestamp: unix_time_ms,
        open: parse_float(open),
        high: parse_float(high),
        low: parse_float(low),
        close: parse_float(close),
        base_volume: parse_float(volume)
      }
    end
  end

  defp parse_float(term) when is_binary(term) do
    {float, _} = Float.parse(term)
    float
  end

  defp parse_float(term) when is_float(term), do: term
  defp parse_float(term) when is_integer(term), do: term
  defp parse_float(nil), do: nil
end
