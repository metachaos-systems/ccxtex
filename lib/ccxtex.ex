defmodule Ccxtex do
  use Export.Python

  @moduledoc """
  Ccxtex main module
  """

  @doc """
  Usage example:

  `exchanges = fetch_exchanges(@pid)`


  Return value example:

  ```
  [
  ...
  %{
  has: %{
    cancel_order: true,
    cancel_orders: false,
    cors: false,
    create_deposit_address: true,
    create_limit_order: true,
    create_market_order: false,
    create_order: true,
    deposit: false,
    edit_order: true,
    fetch_balance: true,
    fetch_closed_orders: "emulated",
    fetch_currencies: true,
    fetch_deposit_address: true,
    fetch_funding_fees: false,
    fetch_l2_order_book: true,
    fetch_markets: true,
    fetch_my_trades: true,
    fetch_ohlcv: true,
    fetch_open_orders: true,
    fetch_order: "emulated",
    fetch_order_book: true,
    fetch_order_books: false,
    fetch_orders: "emulated",
    fetch_ticker: true,
    fetch_tickers: true,
    fetch_trades: true,
    fetch_trading_fees: true,
    private_api: true,
    public_api: true,
    withdraw: true
  },
  id: "poloniex",
  timeout: 10000
  }
  ]
  ```
  """
  @spec fetch_exchanges() :: {:ok, map} | {:error, any}
  def fetch_exchanges() do
    call_default(Ccxtex.Port, "fetch_exchanges")
  end

  @spec fetch_markets_for_exchange(String.t()) :: {:ok, map} | {:error, any}
  def fetch_markets_for_exchange(exchange) do
    call_default(exchange, "fetch_markets_for_exchange", [exchange])
  end

  @doc """
  Usage:

  ```
  exchange = "bitstamp"
  pair_symbol = "ETH/USD"
  ticker = fetch_ticker(@pid, exchange, pair_symbol)
  ```

  Return value example:
  ```
  %{
  ask: 577.35,
  ask_volume: nil,
  average: nil,
  base_volume: 73309.52075575,
  bid: 576.8,
  bid_volume: nil,
  change: nil,
  close: 577.35,
  datetime: "2018-05-24T14:06:09.000Z",
  high: 619.95,
  info: %{
    ask: "577.35",
    bid: "576.80",
    high: "619.95",
    last: "577.35",
    low: "549.28",
    open: "578.40",
    timestamp: "1527170769",
    volume: "73309.52075575",
    vwap: "582.86"
  },
  last: 577.35,
  low: 549.28,
  open: 578.4,
  percentage: nil,
  previous_close: nil,
  quote_volume: 42729187.26769644,
  pair_symbol: "ETH/USD",
  timestamp: 1527170769000,
  vwap: 582.86
  }
  ```
  """
  @spec fetch_ticker(String.t(), String.t()) :: {:ok, map} | {:error, any}
  def fetch_ticker(exchange, pair_symbol) do
    call_default(exchange, "fetch_ticker", [exchange, pair_symbol])
  end

  @doc """
  Usage:

  ```
  exchange = "bitfinex2"
  pair_symbol = "ETH/USDT"
  timeframe = "1h"
  since = ~N[2018-01-01T00:00:00]
  limit = 1000
  ohlcvs = fetch_ohlcvs(@pid, exchange, pair_symbol, timeframe, since, limit)
  ```

  Return value example:
  ```
  %{
  base: "ETH",
  base_volume: 4234.62695691,
  close: 731.16,
  exchange: "bitfinex2",
  high: 737.07,
  low: 726,
  open: 736.77,
  quote: "USDT",
  timestamp: ~N[2018-01-01 00:00:00.000]
  }
  ```
  """
  @spec fetch_ohlcvs(String.t(), String.t(), String.t(), NaiveDateTime.t()) ::
          {:ok, [map]} | {:error, any}
  def fetch_ohlcvs(exchange, pair_symbol, timeframe, since \\ nil, limit \\ nil) do
    [base, quote] = String.split(pair_symbol, "/")

    since =
      if since do
        since
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix(:millisecond)
      else
        since
      end

    with {:ok, res} <-
           call_default(exchange, "fetch_ohlcv", [exchange, pair_symbol, timeframe, since, limit]) do
      ohlcvs =
        res
        |> parse_ohlcvs()
        |> Enum.map(&Map.merge(&1, %{base: base, quote: quote, exchange: exchange}))

      {:ok, ohlcvs}
    else
      err -> err
    end
  end

  defp parse_ohlcvs(raw_ohlcvs) do
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

  defp call_default(exchange, fn_name, args \\ []) do
    process_name =
      case exchange do
        Ccxtex.Port -> Ccxtex.Port
        _ -> String.to_atom("ccxt_exchange_#{exchange}")
      end

    res = Python.call(process_name, "ccxt_port", fn_name, args)
    data = Poison.Parser.parse!(res)
    data = convert_keys_to_atoms(data)
    {:ok, data}
  end

  defp convert_keys_to_atoms(x) do
    AtomicMap.convert(x, %{safe: false})
  end

  defp parse_float(term) when is_binary(term) do
    {float, _} = Float.parse(term)
    float
  end

  defp parse_float(term) when is_float(term), do: term
  defp parse_float(term) when is_integer(term), do: term
  defp parse_float(nil), do: nil
end
