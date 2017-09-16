defmodule Cldr.LanguageTag do
  defstruct language: nil, script: nil, region: nil, variant: nil, locale: %{},
            transforms: %{}, extensions: %{}, private_use: []
end