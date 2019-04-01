defmodule Ccxtex.Market do
  use TypedStruct

  typedstruct do
    field :active, boolean()
    field :base, String.t()
    field :base_id, String.t()
    field :id, String.t()
    field :info, map()
    field :limits, map()
    field :precision, map()
    field :quote, String.t()
    field :quote_id, String.t()
    field :symbol, String.t()
    field :symbol_id, String.t()
    field :altname, String.t()
    field :darkpool, boolean()
    field :maker, float()
    field :taker, float()
  end
end
