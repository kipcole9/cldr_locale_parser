defmodule Cldr.Language.Macro do
  defmacro is_alpha(c) do
    quote do
      unquote(c) in ?a..?z
    end
  end

  defmacro is_digit(c) do
    quote do
      unquote(c) in ?0..?9
    end
  end

  defmacro is_alnum(c) do
    quote do
      unquote(c) in ?a..?z or unquote(c) in ?0..?9
    end
  end
end