defmodule ExOkex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_okex,
      version: "0.0.1",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      name: "ExOkex",
      description: "OKEx API client for Elixir",
      source_url: "https://github.com/yurikoval/ex_okex"
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:mock, "~> 0.2.1", only: :test},
      {:credo, "~> 0.8.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:websockex, "~> 0.4.0"}
    ]
  end

  defp docs do
    [
      main: "ExOkex",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      name: :ex_okex,
      maintainers: ["Yuri Koval'ov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yurikoval/ex_okex"}
    ]
  end
end
