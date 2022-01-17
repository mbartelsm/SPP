-module(team_member).
-export([
    init/1
]).


% Inits

init(Network) ->
    % Start the supervisor and make it spawn us
    super:init(fun(N) -> deploy(N) end, Network).


deploy(Network) ->
    Count = state:get(remaining, Network),
    log:info(?MODULE_STRING, "deploying member ~B", [Count]),

    NewNetwork = if
        Count >  0 -> make_coworker(Network, Count);
        Count =< 0 -> connect_to_lead(Network)
    end,

    await_quote(NewNetwork).


make_coworker(Network, Count) ->
    Lead = state:get(lead, Network),

    CoNet_0 = state:add(lead, Lead),
    CoNet_1 = state:add(remaining, Count - 1, CoNet_0),
    CoPid = spawn(fun() -> team_member:init(CoNet_1) end),

    state:add(next, CoPid, Network).


connect_to_lead(Network) ->
    Lead = state:get(lead, Network),
    state:add(next, Lead, Network).


% States

await_quote(Network) ->
    log:info(?MODULE_STRING, "awaiting quote"),
    { _, Msg } = proc:receive_msg(Network),

    case Msg of
        { quote, Quote } ->
            forward_quote(Network, Quote);

        _                ->
            log:error(?MODULE_STRING, "bad protocol"),
            proc:bad_protocol(Network)
    end.


forward_quote(Network, Quote) ->
    log:info(?MODULE_STRING, "forwarding quote"),
    Next = state:get(next, Network),
    NewQuote = generate_quote(Quote),

    proc:deliver_msg(Network, Next, { quote, NewQuote }),
    log:warn(?MODULE_STRING, "finished"),
    proc:finished(Network).


generate_quote({ Value, Rand }) ->
    { Plus, NewRand } = rand:uniform_s(100, Rand),
    { Value + Plus, NewRand }.
