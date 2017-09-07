  % Parse CLDR Language Tag (local tage)

  Nonterminals langtag language extlang script region variant extension singleton_list
               private_use private_list locale keyword key type type_list keyword_list
               attribute attribute_list sep alpha23 alpha58 alnum18 alnum28 alnum38
               alpha23 alpha 58.

  Terminals plus minus format currency_1 currency_2 currency_3 currency_4 percent
    permille literal semicolon pad quote quoted_char.

  Rootsymbol language_tag.

  %  Language-Tag  = langtag             ; normal language tags
  %                / privateuse          ; private use tag
  %                / grandfathered       ; grandfathered tags
  language_tag    -> langtag.

  %  langtag       = language
  %                  ["-" script]
  %                  ["-" region]
  %                  *("-" variant)
  %                  *("-" extension)
  %                  ["-" privateuse]
  langtag          -> language sep script sep region sep variants sep extensions sep private_use.
  langtag          -> language sep script sep region sep variants sep extensions.
  langtag          -> language sep script sep region sep variants.
  langtag          -> language sep script sep region.
  langtag          -> language sep script.
  langtag          -> language.

  langtag          -> language sep region sep variants sep extensions sep private_use.
  langtag          -> language sep region sep variants sep extensions.
  langtag          -> language sep region sep variants.
  langtag          -> language sep region.

  langtag          -> language sep variants sep extensions sep private_use.
  langtag          -> language sep variants sep extensions.
  langtag          -> language sep variants.

  langtag          -> language sep extensions sep private_use.
  langtag          -> language sep extensions.

  langtag          -> language sep private_use.

  %  language      = 2*3ALPHA            ; shortest ISO 639 code
  %                  ["-" extlang]       ; sometimes followed by
  %                                      ; extended language subtags
  %                / 4ALPHA              ; or reserved for future use
  %                / 5*8ALPHA            ; or registered language subtag
  language         -> alpha23.
  language         -> alpha23 sep extlang.
  language         -> alpha4.
  language         -> alpha58.

  %  extlang       = 3ALPHA              ; selected ISO 639 codes
  %                  *2("-" 3ALPHA)      ; permanently reserved
  extlang          -> alpha3.
  extlang          -> alpha3 sep alpha3.
  extlang          -> alpha3 sep alpha3 sep alpha3.

  %  script        = 4ALPHA              ; ISO 15924 code
  script           -> alpha4.

  %
  %  region        = 2ALPHA              ; ISO 3166-1 code
  %                / 3DIGIT              ; UN M.49 code
  region           -> alpha2.
  region           -> digit3.
  %
  %  variant       = 5*8alphanum         ; registered variants
  %                / (DIGIT 3alphanum)
  variant          -> alnum58.
  variant          -> digit alnum3.

  %  extension     = singleton 1*("-" (2*8alphanum))
  extension        -> singleton sep singleton_list.
  extension        -> locale locale_list.
  extension        -> transform transform_list.
  singleton_list   -> alnum28.
  singleton_list   -> alnum28 sep singleton_list.

  %                                      ; Single alphanumerics
  %                                      ; "x" reserved for private use
  %  singleton     = DIGIT               ; 0 - 9
  %                / %x41-57             ; A - W
  %                / %x59-5A             ; Y - Z
  %                / %x61-77             ; a - w
  %                / %x79-7A             ; y - z
  %  Singleton is define in the lexer

  %  privateuse    = "x" 1*("-" (1*8alphanum))
  private_use      -> private sep private_list.
  private_list     -> alnum18.
  private_list     -> alnum18 sep private_list.

  %  The following is the syntax for the extensions managed
  %  by CLDR.  These are exntensions "u" for locale and "t"
  %  for transforms
  %
  %  locale        = "u"  (1*("-" keyword) / 1*("-" attribute) *("-" keyword))
  locale           -> sep keyword_list
  locale           -> sep attribute_list.
  locale           -> sep attribute_list keyword_list.

  %  keyword       = key ["-" type]
  %  key           = alphanum ALPHA
  %  type          = 3*8alphanum *("-" 3*8alphanum)
  keyword          -> key.
  keyword          -> key sep type.

  key              -> alnum alpha.

  type             -> alnum38.
  type             -> alnum38 sep type_list.
  type_list        -> type.
  type_list        -> type sep type_list.

  keyword_list     -> keyword.
  keyword_list     -> keyword sep keyword_list.

  %  attribute     = 3*8alphanum
  attribute        -> alnum38.
  attribute_list   -> attribute.
  attribute_list   -> attribute sep attribute_list.

  %  The following are part of the standard but are not supported
  %  as legal syntax by this parser.
  %
  %  grandfathered = irregular           ; non-redundant tags registered
  %                / regular             ; during the RFC 3066 era
  %
  %  irregular     = "en-GB-oed"         ; irregular tags do not match
  %                / "i-ami"             ; the 'langtag' production and
  %                / "i-bnn"             ; would not otherwise be
  %                / "i-default"         ; considered 'well-formed'
  %                / "i-enochian"        ; These tags are all valid,
  %                / "i-hak"             ; but most are deprecated
  %                / "i-klingon"         ; in favor of more modern
  %                / "i-lux"             ; subtags or subtag
  %                / "i-mingo"           ; combination
  %                / "i-navajo"
  %                / "i-pwn"
  %                / "i-tao"
  %                / "i-tay"
  %                / "i-tsu"
  %                / "sgn-BE-FR"
  %                / "sgn-BE-NL"
  %                / "sgn-CH-DE"
  %
  %  regular       = "art-lojban"        ; these tags match the 'langtag'
  %                / "cel-gaulish"       ; production, but their subtags
  %                / "no-bok"            ; are not extended language
  %                / "no-nyn"            ; or variant subtags: their meaning
  %                / "zh-guoyu"          ; is defined by their registration
  %                / "zh-hakka"          ; and all of these are deprecated
  %                / "zh-min"            ; in favor of a more modern
  %                / "zh-min-nan"        ; subtag or sequence of subtags
  %                / "zh-xiang"
  %
  %  alphanum      = (ALPHA / DIGIT)     ; letters and numbers

  sep              -> separator.

  alpha23          -> alpha2.
  alpha23          -> alpha3.

  alpha58          -> alpha5.
  alpha58          -> alpha6.
  alpha58          -> alpha7.
  alpha58          -> alpha8.

  alnum38          -> alnum3.
  alnum38          -> alnum4.
  alnum38          -> alnum5.
  alnum38          -> alnum6.
  alnum38          -> alnum7.
  alnum38          -> alnum8.

  alnum28          -> alnum38.
  alnum28          -> alnum2.

  alnum18          -> alnum28.
  alnum18          -> alnum1.

  % Code Type  Value  Description in Referenced Standards
  % Language  und  Undetermined language
  % Script  Zzzz  Code for uncoded script, Unknown [UAX24]
  % Region    ZZ  Unknown or Invalid Territory
  % Currency  XXX  The codes assigned for transactions where no currency is involved
  % Time Zone  unk  Unknown or Invalid Time Zone
  % Subdivision  ZZZZ  Unknown or Invalid Subdivision


  Erlang code.

  % If there is no negative pattern then build the default one
  negative(_Positive) ->
    {negative, [{minus, "-"}, {format, same_as_positive}]}.

  % Append list items.  Consolidate literals if possible into
  % a single list element.
  append([{literal, Literal1}], [{literal, Literal2} | Rest]) ->
    [{literal, list_to_binary([Literal1, Literal2])}] ++ Rest;
  append(A, B) when is_list(A) and is_list(B) ->
    A ++ B.

  format(F) ->
    [{format, F}].

  % Doesn't matter what the negative format is
  % its always the same as the positive one
  % with potentially different suffix and prefix
  neg_format(_F) ->
    [{format, same_as_positive}].

  pad(V) ->
    [{pad, unwrap(V)}].

  % Return a token value
  unwrap({_,_,V}) when is_list(V) -> unicode:characters_to_binary(V);
  unwrap({_,_,V}) -> V.

