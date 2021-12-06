-module(timer_test).
-export([
    sleep_this/0,
    sleep_linked/0,
    sleep_unlinked/0
]).

sleep_this() ->
    timer:sleep(5000),
    result.

sleep_linked() ->
    spawn_link(fun() -> timer:sleep(5000) end),
    result.

sleep_unlinked() ->
    spawn(fun() -> timer:sleep(5000) end),
    result.
