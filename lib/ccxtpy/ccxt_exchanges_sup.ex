defmodule Ccxtex.ExchangeSupervisor do
  @moduledoc """
  Exchange Supervisor is responsible for initializing and monitoring Python port processes for individual exchanges.
  """
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    {:ok, exchanges} = Ccxtex.fetch_exchanges()

    children = for {_k, %{id: id}} <- exchanges do
      name = String.to_atom("ccxt_exchange_#{id}")
      {Ccxtex.Port, [name]}
    end


    Supervisor.init(children, strategy: :one_for_one)
  end
end
