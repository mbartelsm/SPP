%% Module containing the logic for the team members
-module(team_member).
-export([
    init/1
]).


%% Defers initialization to a supervisor
init(Network) ->
    super:init(fun(N) -> deploy(N) end, Network).


%% Deploys the next team member, or if finished deploying, link self to the team
%% leader to forward the last quote to it.
deploy(Network) ->
    Count = state:get(remaining, Network),
    log:debug(?MODULE_STRING, "deploying member ~B", [Count]),

    NewNetwork = if
        Count >  0 -> make_coworker(Network, Count);
        Count =< 0 -> connect_to_lead(Network)
    end,

    await_quote(NewNetwork).


%% Makes next team member
make_coworker(Network, Count) ->
    Lead = state:get(lead, Network),

    CoNet_0 = state:add(lead, Lead),
    CoNet_1 = state:add(remaining, Count - 1, CoNet_0),
    CoPid = spawn(fun() -> team_member:init(CoNet_1) end),

    state:add(next, CoPid, Network).


%% Makes the team leader the last recipient
connect_to_lead(Network) ->
    Lead = state:get(lead, Network),
    state:add(next, Lead, Network).


%% States
%% ---------

%% Awaits for the quote from the previous team member
await_quote(Network) ->
    log:info(?MODULE_STRING, "awaiting quote"),
    { _, Msg } = proc:receive_msg(Network),
    log:info(?MODULE_STRING, "received quote"),

    case Msg of
        { quote, Quote } ->
            forward_quote(Network, Quote);

        _ ->
            log:error(?MODULE_STRING, "bad protocol"),
            proc:bad_protocol(Network)
    end.


%% Forwards the quote + own quote to the next team member
forward_quote(Network, Quote) ->
    Next = state:get(next, Network),
    NewQuote = generate_quote(Quote),

    proc:deliver_msg(Network, Next, { quote, NewQuote }),
    log:warn(?MODULE_STRING, "finished"),
    proc:finished(Network).


%% Generates a random value for the quote
generate_quote({ Value, Rand }) ->
    { Plus, NewRand } = rand:uniform_s(100, Rand),
    { Value + Plus, NewRand }.
