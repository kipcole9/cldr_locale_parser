defmodule Cldr.Locale.Lexer do
  @moduledoc """
  Tokenizes a language tag, typically to support
  parsing it.

  Although RFC6646 does not impose an upper limit
  on the length of a language tag, this implementation
  imposes a limit of 1024 bytes to limit the surface
  area of potential threats.  Given that language
  tags will most usually be user- or browser- sumbitted
  the is a relevant consideration.
  """

  import Cldr.Locale.Macro
  @max_length 1024

  def tokenize(string) when is_binary(string) and byte_size(string) <= @max_length do
    try do
      tokens =
        string
        |> String.downcase
        |> String.replace("_", "-")
        |> String.split("-")
        |> Enum.map(&token_type/1)
      {:ok, tokens}
    catch
      error -> error
    end
  end

  def tokenize(string),
    do: {:error, "Language tag of length #{String.length(string)} exceeds the maximum supported of #{@max_length} bytes."}

  @private_use :private
  defp token_type("x" = chars), do: {@private_use, 1, chars}

  @transform :transform
  defp token_type("t" = chars), do: {@transform, 1, chars}

  @locale :locale
  defp token_type("u" = chars), do: {@locale, 1, chars}

  @singleton :singleton
  defp token_type(<<a::8>> = chars) when a in ?a..?w or a in ?y..?z or a in ?0..?9,
    do: {@singleton, 1, chars}

  @sep :t_field_separator
  defp token_type(<<a::8, b::8>> = separator)
    when is_alpha(a) and is_digit(b), do: {@sep, 2, separator}

  @digit "digit"
  defp token_type(<<a::8>> = digits)
    when is_digit(a), do: format_token {@digit, 1, digits}
  defp token_type(<<a::8, b::8>> = digits)
    when is_digit(a) and is_digit(b), do: format_token {@digit, 2, digits}
  defp token_type(<<a::8, b::8, c::8>> = digits)
    when is_digit(a) and is_digit(b) and is_digit(c), do: format_token {@digit, 3, digits}

  @alpha "alpha"
  defp token_type(<<a::8>> = alpha)
    when is_alpha(a), do: format_token {@alpha, 1, alpha}
  defp token_type(<<a::8, b::8>> = alpha)
    when is_alpha(a) and is_alpha(b), do: format_token {@alpha, 2, alpha}
  defp token_type(<<a::8, b::8, c::8>> = alpha)
    when is_alpha(a) and is_alpha(b) and is_alpha(c), do: format_token {@alpha, 3, alpha}
  defp token_type(<<a::8, b::8, c::8, d::8>> = alpha)
    when is_alpha(a) and is_alpha(b) and is_alpha(c) and is_alpha(d),
    do: format_token {@alpha, 4, alpha}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8>> = alpha)
    when is_alpha(a) and is_alpha(b) and is_alpha(c) and is_alpha(d)
    and is_alpha(e), do: format_token {@alpha, 5, alpha}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8, f::8>> = alpha)
    when is_alpha(a) and is_alpha(b) and is_alpha(c) and is_alpha(d)
    and is_alpha(e) and is_alpha(f), do: format_token {@alpha, 6, alpha}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8, f::8, g::8>> = alpha)
    when is_alpha(a) and is_alpha(b) and is_alpha(c) and is_alpha(d)
    and is_alpha(e) and is_alpha(f) and is_alpha(g), do: format_token {@alpha, 7, alpha}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8, f::8, g::8, h::8>> = alpha)
    when is_alpha(a) and is_alpha(b) and is_alpha(c) and is_alpha(d)
    and is_alpha(e) and is_alpha(f) and is_alpha(g) and is_alpha(h), do: format_token {@alpha, 8, alpha}

  @alnum "alnum"
  defp token_type(<<a::8>> = alnum)
    when is_alnum(a), do: format_token {@alnum, 1, alnum}
  defp token_type(<<a::8, b::8>> = alnum)
    when is_alnum(a) and is_alnum(b), do: format_token {@alnum, 2, alnum}
  defp token_type(<<a::8, b::8, c::8>> = alnum)
    when is_alnum(a) and is_alnum(b) and is_alnum(c), do: format_token {@alnum, 3, alnum}
  defp token_type(<<a::8, b::8, c::8, d::8>> = alnum)
    when is_alnum(a) and is_alnum(b) and is_alnum(c) and is_alnum(d),
    do: format_token {@alnum, 4, alnum}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8>> = alnum)
    when is_alnum(a) and is_alnum(b) and is_alnum(c) and is_alnum(d)
    and is_alnum(e), do: format_token {@alnum, 5, alnum}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8, f::8>> = alnum)
    when is_alnum(a) and is_alnum(b) and is_alnum(c) and is_alnum(d)
    and is_alnum(e) and is_alnum(f), do: format_token {@alnum, 6, alnum}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8, f::8, g::8>> = alnum)
    when is_alnum(a) and is_alnum(b) and is_alnum(c) and is_alnum(d)
    and is_alnum(e) and is_alnum(f) and is_alnum(g), do: format_token {@alnum, 7, alnum}
  defp token_type(<<a::8, b::8, c::8, d::8, e::8, f::8, g::8, h::8>> = alnum)
    when is_alnum(a) and is_alnum(b) and is_alnum(c) and is_alnum(d)
    and is_alnum(e) and is_alnum(f) and is_alnum(g) and is_alnum(h), do: format_token {@alnum, 8, alnum}

  defp token_type(token), do: throw({:error, token})

  defp format_token({token, len, chars}) do
    {String.to_atom(token <> to_string(len)), len, chars}
  end
end