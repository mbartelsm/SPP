-module(team_lead).
-export([
    init/1
]).


% Inits

init(Network) ->
    % Start the supervisor and make it spawn us
    super:init(fun(N) -> private_init(N) end, Network).


private_init(Network) ->
    start_quotes(Network).


% Utils

receive_msg(Network) ->
    Super = state:get_val(super, Network),
    super:get_msg(Super).


deliver_msg(Network, Dest, Msg) ->
    Super = state:get_val(super, Network),
    super:send_msg(Super, Dest, Msg).


% States

start_quotes(Network) ->
    First = state:get_val(first, Network),
    Msg = { quote, 0 },

    deliver_msg(Network, First, Msg),
    await_quote(Network).


await_quote(Network) ->
    { _, Msg } = receive_msg(Network),

    case Msg of
        { quote, Value } -> forward_quote(Network, Value);
        _                -> bad_protocol(Network)
    end.


forward_quote(Network, Value) ->
    Trader = state:get_val(trader, Network),

    deliver_msg(Network, Trader, { quote, Value }),
    receive_answer(Network).


receive_answer(Network) ->
    Trader = state:get_val(trader, Network),
    { Sender, Msg } = receive_msg(Network),

    case { Sender, Msg } of

        { Trader, { answer, _Answer }} -> 
            % TODO: Do something with Answer
            finished(Network);

        _ ->
            bad_protocol(Network)
    end.


finished(Network) ->
    Super = state:get_val(super, Network),
    super:as_finished(Super).


bad_protocol(Network) ->
    Super = state:get_val(super, Network),
    super:as_bad_protocol(Super).
