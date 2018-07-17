defmodule JokenPlug.MixProject do
  use Mix.Project

  def description do
    "An Extensible JWT plug, Built on top of Joken"
  end

  def project do
    [
      app: :joken_plug,
      version: "0.1.0",
      elixir: "~> 1.6",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:joken, "~> 1.5.0"},
      {:poison, "~> 3.1.0"}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs),
      maintainers: ["Matt Hecker"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/HoffsMH/joken-plug"}
    ]
  end
end
