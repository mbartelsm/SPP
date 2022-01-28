-module(kill_proc).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    kill_proc_self(),
    kill_proc_other(),
    kill_proc_monitor(),
    kill_proc_link(),
    ok.

kill_proc_self() ->
    exit(kill).

kill_proc_other() ->
    spawn(fun() -> exit(kill) end).

kill_proc_link() ->
    spawn_link(fun() -> exit(kill) end).

kill_proc_monitor() ->
    spawn_monitor(fun() -> exit(kill) end).
