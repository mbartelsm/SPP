-module(named_fun).
-export([
    start/0
]).

start() ->
    named(),
    ok.

named() ->
    Func = fun Test(X) -> X end,
    Func(test).
