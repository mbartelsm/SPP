-module(proc).
-export([
    receive_msg/1,
    receive_msg_from/2,
    deliver_msg/3,
    finished/1,
    bad_protocol/1
]).

receive_msg(Network) ->
    Super = state:get_val(super, Network),
    super:get_msg(Super).


receive_msg_from(Network, Sender) ->
    Super = state:get_val(super, Network),
    super:get_msg_from(Super, Sender).


deliver_msg(Network, Dest, Msg) ->
    Super = state:get_val(super, Network),
    super:send_msg(Super, Dest, Msg).


finished(Network) ->
    Super = state:get_val(super, Network),
    super:as_finished(Super).


bad_protocol(Network) ->
    Super = state:get_val(super, Network),
    super:as_bad_protocol(Super).
