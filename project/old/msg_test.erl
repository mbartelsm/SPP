-module(msg_test).
-export([
    msg_self_noreceive/0
    , msg_self/0
    , msg_linked/0
%    , msg_unlinked/0
]).

msg_to(Pid) -> Pid ! message.

msg_self_noreceive() ->
    self() ! message.

msg_self() ->
    self() ! message,
    receive
        message -> ok;
        _ -> no
    end.

msg_linked() ->
    Self = self(),
    spawn_link(fun() -> Self ! message end),
    timer:sleep(5),
    receive
        message -> ok;
        _ -> no
    end.

msg_unlinked() ->
    Self = self(),
    spawn(fun() -> Self ! message end),
    timer:sleep(5),
    receive
        message -> ok;
        _ -> no
    end.

%msg_linked() ->
%    Self = self(),
%    spawn_link(fun() -> Self ! message end),
%    receive
%        message -> ok;
%        _ -> no
%    after
%        10000 -> no
%    end.
%
%msg_unlinked() ->
%    Self = self(),
%    spawn(fun() -> Self ! message end),
%    receive
%        message -> ok;
%        _ -> no
%    after
%        10000 -> no
%    end.
