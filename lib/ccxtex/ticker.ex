defmodule Ccxtex.Ticker do
  use TypedStruct

  typedstruct do
    field :info, map()
    field :ask, float()
    field :bid, float()
    field :open, float()
    field :close, float()
    field :high, float()
    field :low, float()
    field :last, float()
    field :average, float()
    field :change, float()
    field :percentage, float()
    field :base_volume, float()
    field :quote_volume, float()
    field :symbol, String.t()
    field :vwap, float()
    field :datetime, NaiveDateTime.t()
    field :timestamp, integer()
  end
end
