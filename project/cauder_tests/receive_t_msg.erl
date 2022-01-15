-module(receive_msg).
-export([
    start/0
]).

start() ->
    process_flag(trap_exit, true),
    self_msg(),
    other_msg(),
    monitored_msg(),
    linked_msg(),
    ok.

self_msg() ->
    Self = self(),
    Self ! {self(), some_msg},
    receive_msg(Self),
    ok.

other_msg() ->
    Self = self(),
    Pid = spawn(fun() -> Self ! {self(), some_msg} end),
    receive_msg(Pid),
    ok.

linked_msg() ->
    Self = self(),
    Pid = spawn_link(fun() -> Self ! {self(), some_msg} end),
    receive_msg(Pid),
    ok.

monitored_msg() ->
    Self = self(),
    Pid = spawn_monitor(fun() -> Self ! {self(), some_msg} end),
    receive_msg(Pid),
    ok.

receive_msg(Pid) ->
    receive {Pid, Msg} -> Msg
    after 2000 -> timeot
    end.