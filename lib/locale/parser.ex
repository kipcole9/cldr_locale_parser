defmodule Cldr.Locale.Parser do
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

  @grammar ABNF.load_file("priv/rfc5646.abnf")

  def parse(locale) when is_list(locale) do
    return_parse_result ABNF.apply(@grammar, "language-tag", locale, %Cldr.LanguageTag{})
  end

  def parse(locale) when is_binary(locale) do
    locale
    |> String.to_charlist
    |> parse
  end

  def lenient_parse(locale) do
    case parse_output = parse(locale) do
      {:ok, result} -> {:ok, result}
      {:error, _reason} -> return_minimum_viable_tag(parse_output)
    end
  end

  defp return_parse_result(%{rest: [], state: state}), do: {:ok, state}
  defp return_parse_result(%{rest: rest}) do
    {:error, {Cldr.InvalidLanguageTag, "Could not parse language tag.  Error was detected at #{inspect rest}"}}
  end

  defp return_minimum_viable_tag(parse_output) do

  end

end
