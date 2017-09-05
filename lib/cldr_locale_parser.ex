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

end
