-module(spawn_link_proc).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    spawn_link_proc(),
    ok.

spawn_link_proc() ->
    spawn_link(fun() -> count(0,5) end),
    ok.

count(Y, Y) -> ok;
count(X, Y) -> count(X+1, Y).
