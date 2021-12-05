-module(test01).
-export([test/2]).


test(
    {_AName, ASize},
    {_BName, BSize}
) when
    ASize =< 0,
    BSize =< 0
->
    {none, 0};


test(
    {_AName, ASize},
    {BName, BSize}
) when
    ASize =< 0
->
    {BName, BSize};


test(
    {AName, ASize},
    {_BName, BSize}
) when
    BSize =< 0
->
    {AName, ASize};


test(
    {AName, ASize},
    {BName, BSize}
) ->
    DiffA = 0.01 * BSize + 1,
    DiffB = 0.01 * ASize + 1,
    test({AName, ASize - DiffA}, {BName, BSize - DiffB}).
    