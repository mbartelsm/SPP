-module(super).
-export([
    init/2,
    send_msg/3,
    get_msg/1,
    get_msg_from/2,
    as_finished/1,
    as_bad_protocol/1
]).


init(Function, Network) ->
    Self = self(),
    log:debug(?MODULE, "Starting supervisor at ~w", [Self]),
    NewNetwork = state:add(super, Self, Network),

    Process = spawn(fun () -> Function(NewNetwork) end),
    log:debug(?MODULE, "Starting process at ~w", [Process]),
    supervise(Process).


supervise(Process) ->
    receive

        % From process to outside
        { Process, Dest, Msg } ->
            Dest ! { self(), Msg },
            ping_or_exit(Process);

        % Request from process
        { Process, Msg } ->
            log:warn(?MODULE_STRING, "Handling state ~w from ~w", [Msg, Process]),
            handle_state(Process, Msg),
            ping_or_exit(Process);

        % From outside to process
        { Sender, Msg } ->
            Process ! { self(), Sender, Msg },
            ping_or_exit(Process)
    end,
    
    supervise(Process).


handle_state(Process, Request) ->
    case Request of
        finished -> terminate(Process);
        bad_protocol -> terminate(Process, bad_protocol);
        Other -> terminate(Process, Other)
    end.


ping_or_exit(Process) ->
    Alive = is_process_alive(Process),
    if
        Alive == true -> ok;
        Alive == false -> terminate(Process, process_dead)
    end.


terminate(Process) ->
    log:warn(?MODULE_STRING, "terminating ~w with ~w", [self(), normal]),
    exit(Process, normal),
    exit(normal).

terminate(Process, Reason) ->
    log:warn(?MODULE_STRING, "terminating ~w with ~w", [self(), Reason]),
    exit(Process, Reason),
    exit(Reason).


send_msg(Super, Dest, Msg) ->
    Super ! { self(), Dest, Msg }.


get_msg(Super) ->
    receive
        { Super, Sender, Msg } -> { Sender, Msg }
    end.


get_msg_from(Super, Sender) ->
    receive
        { Super, Sender, Msg } -> { Sender, Msg }
    end.


as_finished(Super) ->
    log:warn(?MODULE_STRING, "finished ~w", [self()]),
    Super ! { self(), finished },
    exit(normal).


as_bad_protocol(Super) ->
    Super ! { self(), bad_protocol },
    exit(bad_protocol).
