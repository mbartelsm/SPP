%% Common utilities shared by processes for communication to and from
%% supervisors.
-module(proc).
-export([
    receive_msg/1,
    receive_msg_from/2,
    deliver_msg/3,
    finished/1,
    bad_protocol/1,
    inbox/1
]).


%% Fetches the first message from the supervisor's queue
receive_msg(Network) ->
    Super = state:get(super, Network),
    super:get_msg(Super).


%% Fetches a message from a specific sender from the supervisor's queue
receive_msg_from(Network, Sender) ->
    Super = state:get(super, Network),
    super:get_msg_from(Super, Sender).


%% Sends a message through the supervisor to the specifiec destinatary
deliver_msg(Network, Dest, Msg) ->
    Super = state:get(super, Network),
    super:send_msg(Super, Dest, Msg).


%% Informs the supervisor that the process has terminated normally
finished(Network) ->
    Super = state:get(super, Network),
    super:as_finished(Super).


%% Informs the supervisor that the process has terminated due to a bad protocol
bad_protocol(Network) ->
    Super = state:get(super, Network),
    super:as_bad_protocol(Super).


%% Fetches the supervisor's PID
inbox(Network) ->
    state:get(super, Network).
