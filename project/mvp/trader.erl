% Gets quotes from two teams
% Accepts one but not the other
-module(trader).
-export([
    init/1
]).


% Inits

init(Network) ->
    % Start the supervisor and make it spawn us
    super:init(fun(N) -> private_init(N) end, Network).


private_init(Network) ->
    await_quote_alice(Network).


% States

await_quote_alice(Network) ->
    Alice = state:get_val(alice, Network),
    { _, Msg } = proc:receive_msg_from(Network, Alice),

    case Msg of
        { quote, Value } -> 
            Reply = await_quote_bob(Network, Value),
            proc:deliver_msg(Network, Alice, { reply, Reply }),
            proc:finished();

        _ ->
            proc:bad_protocol(Network)
    end.
    

await_quote_bob(Network, AliceOffer) ->
    Bob = state:get_val(bob, Network),
    { _, Msg } = proc:receive_msg_from(Network, Bob),

    case Msg of
        { quote, Value } -> 
            if
                Value <  AliceOffer ->
                    proc:deliver_msg(Network, Bob, { reply, accept }),
                    ReplyAlice = reject;

                Value >= AliceOffer ->
                    proc:deliver_msg(Network, Bob, { reply, reject }),
                    ReplyAlice = accept
            end;

        _ ->
            proc:bad_protocol(Network),
            ReplyAlice = unreachable  % Silence warning, bad_protocol does not return.
    end,
    ReplyAlice.
