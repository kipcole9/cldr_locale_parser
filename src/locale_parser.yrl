  % Parse CLDR Language Tag (local tage)

  Nonterminals langtag language extlang script region singleton_list
               private_use private_list locale keyword key type type_list keyword_list
               attribute attribute_list sep alnum58 alnum18 alnum28 alnum38
               alpha23 alpha58 language_tag variant extension variants extensions.

  Terminals alpha1 alpha2 alpha3 alpha4 alpha5 alpha6 alpha7 alpha8 separator singleton
            alnum2 alnum3 alnum4 alnum5 alnum6 alnum7 alnum8 digit3
            transform_list locale_list private alnum1 transform digit u.

  Left 100 alpha23.
  Left 200 alpha3.
  Left 300 alnum28.
  Left 400 alnum38.
  Left 500 type.
  Left 600 keyword.


  Rootsymbol language_tag.

  %  Language-Tag  = langtag             ; normal language tags
  %                / privateuse          ; private use tag
  %                / grandfathered       ; grandfathered tags
  language_tag    -> langtag : '$1'.

  %  langtag       = language
  %                  ["-" script]
  %                  ["-" region]
  %                  *("-" variant)
  %                  *("-" extension)
  %                  ["-" privateuse]
  langtag          -> language sep script sep region sep variants sep extensions sep private_use.
  langtag          -> language sep script sep region sep variants sep extensions.
  langtag          -> language sep script sep region sep variants.
  langtag          -> language sep script sep region : ['$1', '$3', '$5'].
  langtag          -> language sep script : ['$1', '$3'].
  langtag          -> language.

  langtag          -> language sep region sep variants sep extensions sep private_use.
  langtag          -> language sep region sep variants sep extensions.
  langtag          -> language sep region sep variants.
  langtag          -> language sep region : ['$1', '$3'].

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
  language         -> alpha23 : {language, '$1'}.
  language         -> alpha23 sep extlang.
  language         -> alpha4 : {language, '$1'}.
  language         -> alpha58 : {language, '$1'}.

  %  extlang       = 3ALPHA              ; selected ISO 639 codes
  %                  *2("-" 3ALPHA)      ; permanently reserved
  extlang          -> alpha3.
  extlang          -> alpha3 sep alpha3.
  extlang          -> alpha3 sep alpha3 sep alpha3.

  %  script        = 4ALPHA              ; ISO 15924 code
  script           -> alpha4 : {script, unwrap('$1')}.

  %
  %  region        = 2ALPHA              ; ISO 3166-1 code
  %                / 3DIGIT              ; UN M.49 code
  region           -> alpha2 : {region, unwrap('$1')}.
  region           -> digit3 : {region, unwrap('$1')}.
  %
  %  variant       = 5*8alnumnum         ; registered variants
  %                / (DIGIT 3alnumnum)
  variants         -> variant.
  variants         -> variant variants.
  variant          -> alnum58.
  variant          -> digit alnum3.

  %  extension     = singleton 1*("-" (2*8alnumnum))
  extensions       -> extension.
  extensions       -> extension extensions.

  extension        -> singleton sep singleton_list.
  extension        -> locale locale_list.
  extension        -> transform transform_list.
  singleton_list   -> alnum28.
  singleton_list   -> alnum28 sep singleton_list.

  %                                      ; Single alnumnumerics
  %                                      ; "x" reserved for private use
  %  singleton     = DIGIT               ; 0 - 9
  %                / %x41-57             ; A - W
  %                / %x59-5A             ; Y - Z
  %                / %x61-77             ; a - w
  %                / %x79-7A             ; y - z
  %  Singleton is define in the lexer

  %  privateuse    = "x" 1*("-" (1*8alnumnum))
  private_use      -> private sep private_list.

  private_list     -> alnum18.
  private_list     -> alnum18 sep private_list.

  %  The following is the syntax for the extensions managed
  %  by CLDR.  These are exntensions "u" for locale and "t"
  %  for transforms
  %
  %  locale        = "u"  (1*("-" keyword) / 1*("-" attribute) *("-" keyword))
  locale           -> u sep keyword_list.
  locale           -> u sep attribute_list.
  locale           -> u sep attribute_list keyword_list.

  %  keyword       = key ["-" type]
  %  key           = alnumnum ALPHA
  %  type          = 3*8alnumnum *("-" 3*8alnumnum)
  keyword          -> key : {'$1', nil}.
  keyword          -> key sep type : {'$1', '$3'}.

  key              -> alnum1 alpha1 : combine('$1', '$2').

  type             -> alnum38 : '$1'.
  type             -> alnum38 sep type_list : append('$1', '$3').
  type_list        -> type : '$1'.
  type_list        -> type sep type_list : append('$1', '$3').

  keyword_list     -> keyword.
  keyword_list     -> keyword sep keyword_list.

  %  attribute     = 3*8alnumnum
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
  %  alnumnum      = (ALPHA / DIGIT)     ; letters and numbers

  sep              -> separator.

  alpha23          -> alpha2 : unwrap('$1').
  alpha23          -> alpha3 : unwrap('$1').

  alpha58          -> alpha5 : unwrap('$1').
  alpha58          -> alpha6 : unwrap('$1').
  alpha58          -> alpha7 : unwrap('$1').
  alpha58          -> alpha8 : unwrap('$1').

  alnum58          -> alnum5 : unwrap('$1').
  alnum58          -> alnum6 : unwrap('$1').
  alnum58          -> alnum7 : unwrap('$1').
  alnum58          -> alnum8 : unwrap('$1').

  alnum38          -> alnum3 : unwrap('$1').
  alnum38          -> alnum4 : unwrap('$1').
  alnum38          -> alnum58 : unwrap('$1').

  alnum28          -> alnum38 : unwrap('$1').
  alnum28          -> alnum2 : unwrap('$1').

  alnum18          -> alnum28 : unwrap('$1').
  alnum18          -> alnum1 : unwrap('$1').


  % Code Type  Value  Description in Referenced Standards
  % Language  und  Undetermined language
  % Script  Zzzz  Code for uncoded script, Unknown [UAX24]
  % Region    ZZ  Unknown or Invalid Territory
  % Currency  XXX  The codes assigned for transactions where no currency is involved
  % Time Zone  unk  Unknown or Invalid Time Zone
  % Subdivision  ZZZZ  Unknown or Invalid Subdivision


  Erlang code.

  % % Append list items.  Consolidate literals if possible into
  % % a single list element.
  % append([{literal, Literal1}], [{literal, Literal2} | Rest]) ->
  %   [{literal, list_to_binary([Literal1, Literal2])}] ++ Rest;
  % append(A, B) when is_list(A) and is_list(B) ->
  %   A ++ B.

  % Return a token value
  unwrap({_,_,V}) when is_list(V) -> unicode:characters_to_binary(V);
  unwrap({_,_,V}) -> V.

  combine({_, _, V1}, {_, _, V2}) -> unicode:characters_to_binary(V1 ++ V2).

  % debug(X) ->
  %   {T, _, S} = X,
  %   io:format("~w: ~s~n", [T, S]),
  %   X.
  %
  % debug('$undefined', _M) ->
  %   '$undefined';
  % debug(X, M) ->
  %   {T, _, S} = X,
  %   io:format("~s: ~w: ~s~n", [M, T, S]),
  %   X.


