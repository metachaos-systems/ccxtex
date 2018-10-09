defmodule Ccxtex.OHLCVS.Opts do
  use Construct

  structure do
    field :exchange, :string
    field :symbol_base, :string
    field :symbol_quote, :string
    field :timeframe, :string
    field :since, :integer
    field :limit, :limit
  end

end
