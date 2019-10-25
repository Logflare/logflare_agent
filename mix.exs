defmodule LogflareAgent.MixProject do
  use Mix.Project

  def project do
    [
      app: :logflare_agent,
      version: "0.6.2",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Logflare Agent",
      source_url: "https://github.com/Logflare/logflare_agent",
      homepage_url: "https://logflare.app",
      docs: [
        main: "readme",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LogflareAgent.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"},
      {:distillery, "~> 2.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  defp description() do
    "Logflare Agent watches files and sends new lines to Logflare. Ideal for sending Erlang log messages to the Logflare log management and event analytics platform."
  end

  defp package() do
    [
      links: %{"GitHub" => "https://github.com/Logflare/logflare_agent"},
      licenses: ["MIT"]
    ]
  end
end
