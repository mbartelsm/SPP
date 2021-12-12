-module(spawn_proc).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    spawn_proc(),
    ok.

spawn_proc() ->
    spawn(fun() -> count(0,2) end).

count(Y, Y) -> ok;
count(X, Y) -> count(X+1, Y).
