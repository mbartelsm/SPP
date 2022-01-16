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


% States

start_quotes(Network) ->
    First = state:get_val(first, Network),
    Msg = { quote, 0 },

    proc:deliver_msg(Network, First, Msg),
    await_quote(Network).


await_quote(Network) ->
    { _, Msg } = proc:receive_msg(Network),

    case Msg of
        { quote, Value } -> forward_quote(Network, Value);
        _                -> proc:bad_protocol(Network)
    end.


forward_quote(Network, Value) ->
    Trader = state:get_val(trader, Network),

    proc:deliver_msg(Network, Trader, { quote, Value }),
    receive_answer(Network).


receive_answer(Network) ->
    Trader = state:get_val(trader, Network),
    { Sender, Msg } = proc:receive_msg(Network),

    case { Sender, Msg } of

        { Trader, { answer, _Answer }} -> 
            % TODO: Do something with Answer
            proc:finished(Network);

        _ ->
            proc:bad_protocol(Network)
    end.
