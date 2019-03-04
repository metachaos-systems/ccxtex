defmodule Ccxtex do
  alias Ccxtex.OHLCVS.Opts
  alias Ccxtex.{Ticker, Utils, OHLCV, Market}

  @type result_tuple :: {:ok, any} | {:error, String.t()}

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
    with {:ok, exchanges} <- call_js_main(:exchanges, []) do
      {:ok, exchanges}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches a list of ohlcv data, takes OHLCVS.Opts argument

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
  @spec fetch_ohlcvs(OHLCVS.Opts.t()) :: result_tuple
  def fetch_ohlcvs(%Ccxtex.OHLCVS.Opts{} = opts) do
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

    with {:ok, ohlcvs} <- call_js_main(:fetchOhlcvs, [opts]) do
      ohlcvs =
        ohlcvs
        |> Utils.parse_ohlcvs()
        |> Enum.map(&struct!(OHLCV, &1))

      {:ok, ohlcvs}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches ticker for a given exchange, base and quote symbols

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
  @spec fetch_ticker(String.t(), String.t(), String.t()) :: result_tuple
  def fetch_ticker(exchange, base, quote) do
    opts = %{
      exchange: exchange,
      symbol: base <> "/" <> quote
    }

    with {:ok, ticker} <- call_js_main(:fetchTicker, [opts]) do
      to_struct = &struct!(Ticker, &1)
      ticker =
        ticker
        |> MapKeys.to_snake_case()
        |> MapKeys.to_atoms_unsafe!()
        |> to_struct.()

      {:ok, ticker}
    else
      err_tup -> err_tup
    end
  end

  @doc """
  Fetches all or some tickers for a given exchange

  Usage:
  ```
  exchange = "poloniex"
  ticker = fetch_tickers(exchange)
  ```

  Return value example:
  ```
  [
  ...
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
  ...
  ]
  ```
  """
  @spec fetch_tickers([String.t()], map) :: result_tuple
  def fetch_tickers(symbols \\ nil, params \\ nil) do
    with {:ok, tickers} <- call_js_main(:fetchTickers, [symbols, params]) do
      tickers =
        tickers
        |> Enum.map(fn {k, v} -> {k, Map.put(v, "symbol", k)} end)
        |> Enum.map(fn {k, v} -> {k, MapKeys.to_snake_case(v)} end)
        |> Enum.map(fn {k, v} -> {k, MapKeys.to_atoms_unsafe!(v)} end)
        |> Enum.map(fn {k, v} -> {k, struct!(Ticker, v)} end)
        |> Enum.into(Map.new())

      {:ok, tickers}
    else
      err_tup -> process_error(err_tup)
    end
  end

  @doc """
  Fetches markets for a given exchange

  Response example
  ```
  [
  ...
  %Ccxtex.Market{
    active: true,
    base: "ETH",
    base_id: "eth",
    id: "etheur",
    info: %{
      "base_decimals" => 8,
      "counter_decimals" => 2,
      "description" => "Ether / Euro",
      "minimum_order" => "5.0 EUR",
      "name" => "ETH/EUR",
      "trading" => "Enabled",
      "url_symbol" => "etheur"
    },
    limits: %{
      "amount" => %{"min" => 1.0e-8},
      "cost" => %{"min" => 5},
      "price" => %{"min" => 0.01}
    },
    precision: %{"amount" => 8, "price" => 2},
    quote: "EUR",
    quote_id: "eur",
    symbol: "ETH/EUR",
    symbol_id: "eth_eur"
  }
  ...
  ]
  ```
  """
  @spec fetch_markets(String.t()) :: result_tuple
  def fetch_markets(exchange) do
    with {:ok, markets} <- call_js_main(:fetchMarkets, [exchange]) do
      markets =
        markets
        |> Enum.map(&MapKeys.to_snake_case/1)
        |> Enum.map(&MapKeys.to_atoms_unsafe!/1)
        |> Enum.map(&struct!(Market, &1))

      {:ok, markets}
    else
      err_tup -> err_tup
    end
  end

  def call_js_main(jsfn, args) do
    NodeJS.call({"exec.js", jsfn}, args)
  end

  @spec process_error({:error, String.t()}) :: {:error, String.t()}
  defp process_error(errtup = {:error, reason}) do
    cond do
      String.contains?(reason, "fetchTickers not supported") ->
        {:error, "fetchTickers not supported"}

      true ->
        errtup
    end
  end
end
