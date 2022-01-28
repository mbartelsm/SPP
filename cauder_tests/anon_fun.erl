-module(anon_fun).
-export([
    start/0
]).

start() ->
    anon_0(),
    anon_1(),
    ok.

anon_0() ->
    Func = fun() -> test end,
    Func().

anon_1() ->
    Func = fun(X) -> X end,
    Func(test).
