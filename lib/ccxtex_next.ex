defmodule Ccxtex.Next do
  alias Ccxtex.OHLCVS.Opts
  alias Ccxtex.{Ticker, Utils, OHLCV}

  @spec exchanges() :: [String.t()]
  def exchanges() do
    js_fn = {"main.js", :exchanges}

    with {:ok, exchanges} <- NodeJS.call(js_fn, []) do
      {:ok, exchanges}
    else
      err_tup -> err_tup
    end
  end

  @spec fetch_ohlcvs(OHLCVS.Opts.t()) :: {:ok, any} | {:error, String.t()}
  def fetch_ohlcvs(%Ccxtex.OHLCVS.Opts{} = opts) do
    js_fn = {"main.js", :fetchOhlcvs}

    since_unix = if opts.since do
      opts.since
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_unix(:millisecond)
    end

    opts =
      opts
      |> Map.from_struct()
      |> Map.put(:since, since_unix)

    with {:ok, ohlcvs} <- NodeJS.call(js_fn, [opts]) do
      ohlcvs = ohlcvs
      |> Utils.parse_ohlcvs()
      |> Enum.map(&OHLCV.make!/1)
      {:ok, ohlcvs}
    else
      err_tup -> err_tup
    end
  end

  @spec fetch_ticker(String.t, String.t, String.t) :: {:ok, any} | {:error, String.t()}
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

  @spec fetch_markets(String.t) :: {:ok, any} | {:error, String.t()}
  def fetch_markets(exchange) do
    js_fn = {"main.js", :fetchMarkets}

    with {:ok, markets} <- NodeJS.call(js_fn, [exchange]) do
      {:ok, markets}
    else
      err_tup -> err_tup
    end

  end
end
