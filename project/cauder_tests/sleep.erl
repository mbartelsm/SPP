-module(sleep).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    sleep_self(),
    sleep_other(),
    sleep_monitor(),
    sleep_link(),
    ok.

sleep_self() ->
    timer:sleep(2000).

sleep_other() ->
    spawn(fun() -> timer:sleep(2000) end).

sleep_link() ->
    spawn_link(fun() -> timer:sleep(2000) end).

sleep_monitor() ->
    spawn_monitor(fun() -> timer:sleep(2000) end).
