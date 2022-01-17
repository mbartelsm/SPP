-module(trader).
-export([
    init/1
]).


% Inits

init(Network) ->
    % Start the supervisor and make it spawn us
    super:init(fun(N) -> deploy(N) end, Network).


deploy(Network_0) ->
    log:info(?MODULE_STRING, "deploying"),
    Network_1 = make_lead(Network_0, alice),
    Network_2 = make_lead(Network_1, bob),

    await_quote_alice(Network_2).


make_lead(Netowrk, Name) ->
    log:info(?MODULE_STRING, "making ~s", [Name]),
    LeadNet = state:add(trader, self()),
    LeadPid = spawn(fun() -> team_lead:init(LeadNet) end),
    NewNetwork = state:add(Name, LeadPid, Netowrk),
    NewNetwork.


% States

await_quote_alice(Network) ->
    Alice = state:get(alice, Network),
    { _, Msg } = proc:receive_msg_from(Network, Alice),

    case Msg of
        { quote, Value } -> 
            log:info(?MODULE_STRING, "quote from alice is ~B", [Value]),
            Reply = await_quote_bob(Network, Value),
            log:info(?MODULE_STRING, "reply to alice: ~s", [Reply]),
            proc:deliver_msg(Network, Alice, { reply, Reply }),
            log:warn(?MODULE_STRING, "finished"),
            proc:finished();

        _ ->
            log:error(?MODULE_STRING, "bad protocol"),
            proc:bad_protocol(Network)
    end.
    

await_quote_bob(Network, AliceOffer) ->
    Bob = state:get(bob, Network),
    { _, Msg } = proc:receive_msg_from(Network, Bob),

    case Msg of
        { quote, Value } -> 
            log:info(?MODULE_STRING, "quote from bob is ~B", [Value]),
            if
                Value <  AliceOffer ->
                    proc:deliver_msg(Network, Bob, { reply, accept }),
                    log:info(?MODULE_STRING, "reply to bob: accept"),
                    ReplyAlice = reject;

                Value >= AliceOffer ->
                    proc:deliver_msg(Network, Bob, { reply, reject }),
                    log:info(?MODULE_STRING, "reply to bob: reject"),
                    ReplyAlice = accept
            end;

        _ ->
            log:error(?MODULE_STRING, "bad protocol"),
            proc:bad_protocol(Network),
            ReplyAlice = unreachable  % Silence warning, bad_protocol does not return.
    end,
    ReplyAlice.
