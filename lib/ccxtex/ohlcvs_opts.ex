defmodule Ccxtex.OHLCVS.Opts do
  use Construct

  structure do
    field :exchange, :string
    field :base, :string
    field :quote, :string
    field :timeframe, :string
    field :since, :utc_datetime
    field :limit, :integer
  end

end
