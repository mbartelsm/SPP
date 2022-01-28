-module(fold_test).
-export([
    start/0
]).

start() ->
    anonymous_l(),
    anonymous_r(),
    ok.

anonymous_l() ->
    Res = lists:foldl(
        fun(Elem, Sum) -> Elem + Sum end,
        0,
        [1,2,3]
    ),
    Res.

anonymous_r() ->
    Res = lists:foldr(
        fun(Elem, Sum) -> Elem + Sum end,
        0,
        [1,2,3]
    ),
    Res.
