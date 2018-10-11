defmodule Ccxtex.OHLCVS.Opts do
  use Construct

  structure do
    field :exchange, :string
    field :base, :string
    field :quote, :string
    field :timeframe, :string
    field :since, :naive_datetime, default: nil
    field :limit, :integer, default: nil
  end
end
