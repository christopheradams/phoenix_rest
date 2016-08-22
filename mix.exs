defmodule PhoenixRest.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_rest,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [extras: ["README.md"]],
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:phoenix, :plug_rest]]
  end

  defp deps do
    [{:phoenix, "~> 1.1.0"},
     {:plug_rest, "~> 0.7.0"},
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
