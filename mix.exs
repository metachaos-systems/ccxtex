defmodule Ccxtex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ccxtex,
      version: "0.3.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ccxtex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:export, ">= 0.0.0"},
      {:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false},
      {:nodejs, "~> 0.1"},
      {:jason, "~> 1.1"},
      {:construct, "~> 1.0"},
      {:map_keys, "~> 0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :ccxtex,
      files: ["lib", "mix.exs", "README*", "LICENSE*", "priv/js/dist"],
      description: "Call ccxt library for cryptocurrency markets from Elixir/Erlang",
      maintainers: ["ontofractal"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/metachaos-systems/ccxtex",
        "Metachaos Systems" => "http://metachaos.systems",
        "Ccxt" => "https://github.com/ccxt/ccxt"
      }
    ]
  end
end
