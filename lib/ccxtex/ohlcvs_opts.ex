defmodule Ccxtex.OHLCVS.Opts do
  use TypedStruct

  typedstruct do
    field :exchange, String.t(), enforce: true
    field :base, String.t(), enforce: true
    field :quote, String.t(), enforce: true
    field :timeframe, String.t()
    field :since, NaiveDateTime.t()
    field :limit, integer()
  end
end
