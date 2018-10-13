defmodule Ccxtex do
  alias Ccxtex.OHLCVS.Opts
  alias Ccxtex.{Ticker, Utils, OHLCV, Market}

  @moduledoc """
  Ccxtex main module
  """

  @doc """
  Usage example:

  `exchanges = exchanges()`


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
  @spec exchanges() :: [String.t()]
  def exchanges() do
    js_fn = {"main.js", :exchanges}

    with {:ok, exchanges} <- NodeJS.call(js_fn, []) do
      {:ok, exchanges}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Usage:

  ```
  opts =
    Ccxtex.OHLCVS.Opts.make!(%{
      exchange: "poloniex",
      base: "ETH",
      quote: "USDT",
      timeframe: "1h",
      since: ~N[2018-01-01T00:00:00],
      limit: 100
    })
  ohlcvs = fetch_ohlcvs(opts)
  ```

  Return value example:
  ```
  %Ccxtex.OHLCV{
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
  @spec fetch_ohlcvs(OHLCVS.Opts.t()) :: {:ok, any} | {:error, String.t()}
  def fetch_ohlcvs(%Ccxtex.OHLCVS.Opts{} = opts) do
    js_fn = {"main.js", :fetchOhlcvs}

    since_unix =
      if opts.since do
        opts.since
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix(:millisecond)
      end

    opts =
      opts
      |> Map.from_struct()
      |> Map.put(:since, since_unix)

    with {:ok, ohlcvs} <- NodeJS.call(js_fn, [opts]) do
      ohlcvs =
        ohlcvs
        |> Utils.parse_ohlcvs()
        |> Enum.map(&OHLCV.make!/1)

      {:ok, ohlcvs}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Usage:

  ```
  exchange = "bitstamp"
  base = "ETH"
  quote = "USD"
  ticker = fetch_ticker(exchange, base, quote)
  ```

  Return value example:
  ```
  %Ccxtex.Ticker{
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
  @spec fetch_ticker(String.t(), String.t(), String.t()) :: {:ok, any} | {:error, String.t()}
  def fetch_ticker(exchange, base, quote) do
    js_fn = {"main.js", :fetchTicker}

    opts = %{
      exchange: exchange,
      symbol: base <> "/" <> quote
    }

    with {:ok, ticker} <- NodeJS.call(js_fn, [opts]) do
      ticker =
        ticker
        |> MapKeys.to_snake_case()
        |> Ticker.make!()

      {:ok, ticker}
    else
      err_tup -> err_tup
    end
  end

  @spec fetch_markets(String.t()) :: {:ok, any} | {:error, String.t()}
  def fetch_markets(exchange) do
    js_fn = {"main.js", :fetchMarkets}

    with {:ok, markets} <- NodeJS.call(js_fn, [exchange]) do
      markets =
        markets
        |> Enum.map(&MapKeys.to_snake_case/1)
        |> Enum.map(&Market.make!/1)

      {:ok, markets}
    else
      err_tup -> err_tup
    end
  end
end
