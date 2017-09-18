defmodule Cldr.LanguageTag.Parser do
  @moduledoc """
  Parses a CLDR language tag (also referred to as locale string).

  The applicable specification is from [CLDR](http://unicode.org/reports/tr35/#Unicode_Language_and_Locale_Identifiers)
  which is similar based upon [RFC56469](https://tools.ietf.org/html/rfc5646) with some variations.

  This module provides functions to parse a language tag (locale string).  To be
  consistent with the rest of `Cldr`, the term locale string will be preferred.

  There are three core functions:

  * `parse/1` will parse a locale string but will not enforce validity of tags.  This ensures
    the fasted processing a the price of correctness

  * `validate/1` will parse and validate that the locale string is a valid format and that the
    tags and optionally the subtags are also valid.

  * `canonicalize/1` will parse, validate and make canonical the locale string.  Canonicalization
  will apply any CLDR language substitutions and add default script and territory to the parsed
  result. It will also apply the common practise capitalizations (lower case for language, capital
  case for script, upper case for territory.

  """
  alias Cldr.LanguageTag

  @app Mix.Project.config[:app]
  @priv_dir :erlang.list_to_binary(:code.priv_dir(@app))
  @grammar ABNF.load_file(@priv_dir <> "/rfc5646.abnf")

  def parse(locale) when is_list(locale) do
    case return_parse_result(ABNF.apply(@grammar, "language-tag", locale, %LanguageTag{})) do
      {:ok, language_tag} ->
        normalized_tag =
          language_tag
          |> canonicalize_locale_keys
          |> normalize_lang_script_region
        {:ok, normalized_tag}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def parse(locale) when is_binary(locale) do
    locale
    |> Cldr.Locale.normalize_locale_name
    |> String.to_charlist
    |> parse
  end

  def parse!(locale) do
    case parse(locale) do
      {:ok, language_tag} -> language_tag
      {:error, {exception, reason}} -> raise exception, reason
    end
  end

  def lenient_parse(locale) do
    case parse_output = parse(locale) do
      {:ok, result} -> {:ok, result}
      {:error, reason} -> return_minimum_viable_tag(parse_output.state, reason)
    end
  end

  defp canonicalize_locale_keys(%Cldr.LanguageTag{locale: nil} = language_tag) do
    language_tag
  end

  defp canonicalize_locale_keys(%Cldr.LanguageTag{locale: locale} = language_tag) do
    canon_locale = Enum.map(locale, fn {k, v} ->
      if Map.has_key?(LanguageTag.locale_key_map, k) do
        {LanguageTag.locale_key_map[k], v}
      else
        {k, v}
      end
    end)

    Map.put(language_tag, :locale, canon_locale)
  end

  defp normalize_lang_script_region(%{language: language, script: script, region: region} = language_tag) do
    language = normalize_language(language)
    script = normalize_script(script)
    region = normalize_region(region)

    language_tag
    |> Map.put(:language, language)
    |> Map.put(:script, script)
    |> Map.put(:region, region)
  end

  defp normalize_language(nil), do: nil
  defp normalize_language(language) do
    String.downcase(language)
  end

  defp normalize_script(nil), do: nil
  defp normalize_script(script) do
    script
    |> String.downcase
    |> String.capitalize
  end

  defp normalize_region(nil), do: nil
  defp normalize_region(region) do
    region
    |> String.upcase
  end

  defp return_parse_result(%{rest: [], state: state}), do: {:ok, state}
  defp return_parse_result(%{rest: rest}) do
    {:error, {Cldr.InvalidLanguageTag, "Could not parse language tag.  Error was detected at #{inspect rest}"}}
  end

  defp return_minimum_viable_tag(%{language: language, script: script, region: region} = language_tag, _reason)
  when language != nil and script != nil and region != nil do
    {:ok, language_tag}
  end

  defp return_minimum_viable_tag(_language_tag, reason) do
    {:error, reason}
  end

end
