-module(monitor_proc).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    monitor_proc(),
    ok.

monitor_proc() ->
    monitor(process, spawn(fun() -> count(0,2) end)),
    ok.

count(Y, Y) -> ok;
count(X, Y) -> count(X+1, Y).
