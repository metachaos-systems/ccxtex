defmodule Ccxtex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ccxtex,
      version: "0.3.4",
      elixir: "~> 1.7",
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
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:nodejs, "~> 1.0"},
      {:jason, "~> 1.1"},
      {:typed_struct, "~> 0.1"},
      {:map_keys, "~> 0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :ccxtex,
      files: ["lib", "mix.exs", "README*", "LICENSE*", "priv/js/dist"],
      description: "Call ccxt (cryptocurrency trading library) from Elixir/Erlang",
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
