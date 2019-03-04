defmodule Ccxtex.Market do
  use TypedStruct

  typedstruct do
    field :active, :boolean
    field :base, :string
    field :base_id, :string
    field :id, :string
    field :info, :map
    field :limits, :map
    field :precision, :map
    field :quote, :string
    field :quote_id, :string
    field :symbol, :string
    field :symbol_id, :string
  end
end
