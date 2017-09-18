defmodule Cldr.LanguageTag do
  alias Cldr.LanguageTag.Parser

  defstruct language: nil, script: nil, region: nil, variant: nil, locale: %{},
            transforms: %{}, extensions: %{}, private_use: []

  def locale_key_map do
    %{
      "ca" => :calendar,
      "co" => :collation,
      "ka" => :alternative_collation,
      "kb" => :backward_level2,
      "kc" => :case_level,
      "kn" => :numeric,
      "kh" => :hiaragana_quarternary,
      "kk" => :normalization,
      "kf" => :case_first,
      "ks" => :strength,
      "vt" => :variable_top,
      "cu" => :currency,
      "nu" => :number_system,
      "tz" => :timezone,
      "va" => :variant
    }
  end

  def parse(locale_string) do
    Parser.parse(locale_string)
  end

  def parse!(locale_string) do
    Parser.parse!(locale_string)
  end

  def locale(%{language: language, script: script, region: region}) do
    [language, script, region]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("-")
  end

  def locale(locale_string) when is_binary(locale_string) do
    case Parser.parse(locale_string) do
      {:ok, language_tag} -> locale(language_tag)
      {:error, reason} -> {:error, reason}
    end
  end
end