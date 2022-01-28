%% Module containing the logic for the team leader role (Alice/Bob)/(C/D)
-module(team_lead).
-export([
    init/1
]).


%% Defers initialization to a supervisor
init(Network) ->
    super:init(fun(N) -> deploy(N) end, Network).


%% Deploys subnetwork and starts initial state
deploy(Network) ->
    log:debug(?MODULE_STRING, "deploying"),
    NewNetwork = make_team_members(Network, 5),
    start_quotes(NewNetwork).

%% Chain-initializes the team and returns the updated network state
make_team_members(Network, Count) ->
    MemNet_0 = state:add(lead, proc:inbox(Network)),
    MemNet_1 = state:add(remaining, Count - 1, MemNet_0),
    MemPid = spawn(fun() -> team_member:init(MemNet_1) end),

    state:add(first, MemPid, Network).


%% States
%% ---------

%% Informs the first team member to begin the quoting process
start_quotes(Network) ->
    First = state:get(first, Network),
    Msg = { quote, {0, rand:seed(exsss, 777)} },
    log:info(?MODULE_STRING, "starting quoting procedure"),
    proc:deliver_msg(Network, First, Msg),
    await_quote(Network).


%% Waits for the last quote to arrive
await_quote(Network) ->
    log:info(?MODULE_STRING, "awaiting quote"),
    { _, Msg } = proc:receive_msg(Network),

    case Msg of
        { quote, Value } ->
            forward_quote(Network, Value);

        _Else ->
            log:error(?MODULE_STRING, "bad protocol"),
            proc:bad_protocol(Network)
    end.


%% Forwards the quote to the trader
forward_quote(Network, Value) ->
    Trader = state:get(trader, Network),
    { Val , _ } = Value,
    log:info(?MODULE_STRING, "forwarding quote of ~B to trader", [Val]),

    proc:deliver_msg(Network, Trader, { quote, Value }),
    receive_answer(Network).


%% Awaits for a response from the trader
receive_answer(Network) ->
    Trader = state:get(trader, Network),
    { Sender, Msg } = proc:receive_msg(Network),

    case { Sender, Msg } of

        { Trader, { reply, Answer }} -> 
            log:info(?MODULE_STRING, "received answer: ~s", [Answer]),
            log:warn(?MODULE_STRING, "finished"),
            proc:finished(Network);

        _Else ->
            log:error(?MODULE_STRING, "bad protocol"),
            proc:bad_protocol(Network)
    end.
