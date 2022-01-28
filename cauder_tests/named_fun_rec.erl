-module(named_fun_rec).
-export([
    start/0
]).

start() ->
    named_rec(),
    ok.

named_rec() ->
    Func = fun Test(X) -> Test(X-1); Test(0) -> ok end,
    Func(test).
