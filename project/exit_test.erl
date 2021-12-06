-module(exit_test).
-export([
    kill_self/0,
    kill_other/0,
    kill_unlinked/0,
    exit_self/0,
    exit_other/0,
    exit_unlinked/0,
    unexpected_self/0,
    unexpected_other/0,
    unexpected_unlinked/0
]).

loop() ->
    loop().

kill_self() ->
    exit(kill),
    loop().

kill_other() ->
    Pid = spawn_link(fun() -> loop() end),
    exit(Pid, kill).

kill_unlinked() ->
    Pid = spawn(fun() -> loop() end),
    exit(Pid, kill).

exit_self() ->
    exit(reason),
    loop().

exit_other() ->
    Pid = spawn_link(fun() -> loop() end),
    exit(Pid, reason).

exit_unlinked() ->
    Pid = spawn(fun() -> loop() end),
    exit(Pid, reason).

add2(A, B) -> A + B.

unexpected_self() ->
    add2(2, bad_arg),
    loop().

unexpected_other() ->
    spawn_link(fun() -> add2(2, bad_arg) end),
    loop().

unexpected_unlinked() ->
    spawn(fun() -> add2(2, bad_arg) end),
    loop().
