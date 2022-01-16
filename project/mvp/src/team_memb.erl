-module(team_member).
-export([
    init/1
]).


% Inits

init(Network) ->
    % Start the supervisor and make it spawn us
    super:init(fun(N) -> private_init(N) end, Network).


private_init(Network) ->
    await_quote(Network).


% States

await_quote(Network) ->
    { _, Msg } = proc:receive_msg(Network),

    case Msg of
        { quote, Value } -> forward_quote(Network, Value);
        _                -> proc:bad_protocol(Network)
    end.

forward_quote(Network, Value) ->
    Next = state:get_val(next, Network),

    proc:deliver_msg(Network, Next, { quote, Value }),
    proc:finished(Network).

