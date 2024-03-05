defmodule MatchTrack.MixProject do
  use Mix.Project

  def project do
    [
      app: :match_track,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MatchTrack.Application, []},
      extra_applications: [:logger, :eex, :wx, :observer, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2.2"}
    ]
  end
end
