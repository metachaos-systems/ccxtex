defmodule Ccxtex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  @js_path System.cwd!() <> "/priv/js"
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Ccxtex.Port, [Ccxtex.Port]},
      {Ccxtex.ExchangeSupervisor, []},
      supervisor(NodeJS, [[path: @js_path, pool_size: 4]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ccxtex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
