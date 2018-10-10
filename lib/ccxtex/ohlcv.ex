defmodule Ccxtex.OHLCV do
  use Construct

  structure do
    field :open, :float
    field :close, :float
    field :high, :float
    field :low, :float
    field :base_volume, :float
    field :timestamp, :integer
  end
end
