defmodule PhoenixRest.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_rest,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:phoenix, :plug_rest]]
  end

  defp deps do
    [{:phoenix, "~> 1.1.0"},
     {:plug_rest, "~> 0.7.0"}]
  end
end
