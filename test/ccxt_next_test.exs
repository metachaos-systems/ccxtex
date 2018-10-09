defmodule Ccxtex.NextTest do
  import Ccxtex.Next
  use ExUnit.Case, async: true
  doctest Ccxtex

  test "returns exchanges list" do
    {:ok, exchanges} = exchanges()
    assert ("poloniex" in exchanges) and ("bitfinex" in exchanges)
  end

end
