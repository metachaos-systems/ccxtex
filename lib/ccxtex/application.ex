defmodule Ccxtex.Application do
  @moduledoc false
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    js_path = Application.app_dir(:ccxtex, "priv/js/dist")

    children = [
      supervisor(NodeJS, [[path: js_path, pool_size: 16]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ccxtex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
