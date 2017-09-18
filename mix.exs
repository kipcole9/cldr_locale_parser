defmodule CldrLocaleParser.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ex_cldr_locale_parser,
      version: @version,
      elixir: "~> 1.5",
      name: "Cldr Locale Parser",
      description: description(),
      source_url: "https://github.com/kipcole9/cldr_locale_parser",
      docs: docs(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Cldr locale and RFC5646 Language Tag Parser, normalizer and matcher
    """
  end

  defp deps do
    [
      {:ex_cldr, "~> 0.7.0"},
      {:ex_abnf, "~> 0.2.8"}
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache 2.0"],
      links: links(),
      files: [
        "lib", "priv", "config", "mix.exs", "README*", "CHANGELOG*", "LICENSE*"
      ]
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  def links do
    %{
      "GitHub"    => "https://github.com/kipcole9/cldr_locale_parser",
      "Readme"    => "https://github.com/kipcole9/cldr_locale_parser/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/kipcole9/cldr_locale_parser/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "test"]
  defp elixirc_paths(:dev),  do: ["lib", "mix"]
  defp elixirc_paths(_),     do: ["lib"]
end
