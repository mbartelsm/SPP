-module(callback_fun).
-export([
    start/0
]).

start() ->
    run_0(fun test_0/0),
    run_1(fun test_1/1, test),
    ok.

test_0() -> test.

test_1(X) -> X.

run_0(Func) -> Func().

run_1(Func, Arg) -> Func(Arg).
