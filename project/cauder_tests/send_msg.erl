-module(send_msg).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    send_msg_self(),
    send_msg_other(),
    send_msg_monitored(),
    send_msg_linked(),
    ok.

send_msg_self() ->
    self() ! {self(), some_msg},
    ok.

send_msg_other() ->
    Pid = spawn(fun() -> count(0,5) end),
    Pid ! {self(), some_msg},
    ok.

send_msg_linked() ->
    Pid = spawn_link(fun() -> count(0,5) end),
    Pid ! {self(), some_msg},
    ok.

send_msg_monitored() ->
    Pid = spawn_monitor(fun() -> count(0,5) end),
    Pid ! {self(), some_msg},
    ok.

count(Y, Y) -> ok;
count(X, Y) -> count(X+1, Y).
