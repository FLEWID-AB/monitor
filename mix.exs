defmodule Monitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :monitor,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Monitor, []},
      included_applications: [:vmstats, :fluxter, :instream],
      extra_applications: [:logger, :hackney]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:instream, "~> 0.17"},
      {:vmstats, github: "ferd/vmstats", tag: "2.3.1"},
      {:fluxter, "~> 0.7"}
    ]
  end
end
