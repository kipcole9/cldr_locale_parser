defmodule CldrLocaLeLexerTest do
  use ExUnit.Case

  test "That we can lex valid language tags" do
    assert Cldr.Locale.Lexer.tokenize("en") == {:ok, [{:alpha2, 2, "en"}]}
    assert Cldr.Locale.Lexer.tokenize("en-US") == {:ok, [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}]}
    assert Cldr.Locale.Lexer.tokenize("en-us") == {:ok, [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}]}
    assert Cldr.Locale.Lexer.tokenize("en_us") == {:ok, [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}]}
    assert Cldr.Locale.Lexer.tokenize("es-419") == {:ok, [{:alpha2, 2, "es"}, {:digit3, 3, "419"}]}
    assert Cldr.Locale.Lexer.tokenize("zh-Hans") == {:ok, [{:alpha2, 2, "zh"}, {:alpha4, 4, "hans"}]}
    assert Cldr.Locale.Lexer.tokenize("zh-Hant-TW") == {:ok, [{:alpha2, 2, "zh"}, {:alpha4, 4, "hant"}, {:alpha2, 2, "tw"}]}

    assert Cldr.Locale.Lexer.tokenize("de-DE-u-co-phonebk") ==
      {:ok,
       [{:alpha2, 2, "de"}, {:alpha2, 2, "de"}, {:locale, 1, "u"},
        {:alpha2, 2, "co"}, {:alpha7, 7, "phonebk"}]}

    assert Cldr.Locale.Lexer.tokenize("en-US-x-twain") ==
      {:ok,
       [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}, {:private, 1, "x"},
        {:alpha5, 5, "twain"}]}
  end

  test "That we can lex a tag with t transform definition" do
    assert Cldr.Locale.Lexer.tokenize("und-Cyrl-t-und-latn-m0-ungegn-2007") ==
      {:ok,
       [{:alpha3, 3, "und"}, {:alpha4, 4, "cyrl"}, {:transform, 1, "t"},
        {:alpha3, 3, "und"}, {:alpha4, 4, "latn"}, {:t_field_separator, 2, "m0"},
        {:alpha6, 6, "ungegn"}, {:alnum4, 4, "2007"}]}

    assert Cldr.Locale.Lexer.tokenize("und-Hebr-t-und-latn-m0-ungegn-1972") ==
      {:ok,
       [{:alpha3, 3, "und"}, {:alpha4, 4, "hebr"}, {:transform, 1, "t"},
        {:alpha3, 3, "und"}, {:alpha4, 4, "latn"}, {:t_field_separator, 2, "m0"},
        {:alpha6, 6, "ungegn"}, {:alnum4, 4, "1972"}]}
  end

  test "that we can lex all the locales defined in CLDR" do
    for locale <- Cldr.all_locales do
      assert {:ok, _} = Cldr.Locale.Lexer.tokenize(locale)
    end
  end
end
