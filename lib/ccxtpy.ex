defmodule Ccxtpy do
  use Export.Python

  @moduledoc """
  Ccxtpy main module
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
  def fetch_exchanges(pid) do
    call_default(pid, "fetch_exchanges")
    |> convert_keys_to_atoms()
  end

  def fetch_markets_for_exchange(pid, exchange) do
    call_default(pid, "fetch_markets_for_exchange", [exchange])
    |> convert_keys_to_atoms()
  end

  @doc """
  Usage:

  ```
  exchange = "bitstamp"
  symbol = "ETH/USD"
  ticker = fetch_ticker(@pid, exchange, symbol)
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
