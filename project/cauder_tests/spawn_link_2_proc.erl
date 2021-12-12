-module(spawn_link_2_proc).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    spawn_link_proc(),
    ok.

spawn_link_proc() ->
    Pid = spawn(fun() -> count(0,5) end),
    link(Pid),
    ok.

count(Y, Y) -> ok;
count(X, Y) -> count(X+1, Y).
