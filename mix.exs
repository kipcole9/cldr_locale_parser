defmodule CldrLocaleParser.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :cldr_locale_parser,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:ex_cldr, "~> 0.6.0"}
    ]
  end
end
