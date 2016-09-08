defmodule PhoenixRest.Mixfile do
  use Mix.Project

  @version "0.3.1"

  def project do
    [app: :phoenix_rest,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [plt_add_deps: true],
     docs: [extras: ["README.md"]],
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:phoenix, :plug_rest]]
  end

  defp deps do
    [{:phoenix, "~> 1.1 or ~> 1.2"},
     {:plug_rest, "~> 0.9.0"},
     {:dialyxir, "~> 0.3.5", only: [:dev]},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    """
    Resource routing and REST behaviour for Phoenix applications
    """
  end

  defp package do
    [
     name: :phoenix_rest,
     maintainers: ["Christopher Adams"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/christopheradams/phoenix_rest"}
    ]
  end

end
