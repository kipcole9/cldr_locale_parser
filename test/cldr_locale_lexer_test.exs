defmodule CldrLocaLexerTest do
  use ExUnit.Case

  test "That we can lex valid language tags" do
    assert Cldr.Language.Lexer.tokenize("en") == {:ok, [{:alpha2, 2, "en"}]}
    assert Cldr.Language.Lexer.tokenize("en-US") == {:ok, [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}]}
    assert Cldr.Language.Lexer.tokenize("en-us") == {:ok, [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}]}
    assert Cldr.Language.Lexer.tokenize("en_us") == {:ok, [{:alpha2, 2, "en"}, {:alpha2, 2, "us"}]}
    assert Cldr.Language.Lexer.tokenize("es-419") == {:ok, [{:alpha2, 2, "es"}, {:digit3, 3, "419"}]}
    assert Cldr.Language.Lexer.tokenize("zh-Hans") == {:ok, [{:alpha2, 2, "zh"}, {:alpha4, 4, "hans"}]}
    assert Cldr.Language.Lexer.tokenize("zh-Hant-TW") == {:ok, [{:alpha2, 2, "zh"}, {:alpha4, 4, "hant"}, {:alpha2, 2, "tw"}]}
  end
end
