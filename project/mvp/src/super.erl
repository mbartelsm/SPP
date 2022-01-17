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
    NewNetwork = state:add(super, Self, Network),
    Process = spawn(Function(NewNetwork)),
    supervise(Process).


supervise(Process) ->
    receive

        % From process to outside
        { Process, Dest, Msg } ->
            ping_or_exit(Process),
            Dest ! { self(), Msg };

        % Request from process
        { Process, Msg } ->
            ping_or_exit(Process),
            handle_state(Process, Msg);

        % From outside to process
        { Sender, Msg } ->
            ping_or_exit(Process),
            Process ! { self(), Sender, Msg }

    after
        100000 -> terminate(Process, timeout)
    end,
    
    supervise(Process).


handle_state(Process, Request) ->
    case Request of
        finished -> terminate(Process);
        bad_protocol -> terminate(Process, bad_protocol)
    end.


ping_or_exit(Process) ->
    Alive = is_process_alive(Process),
    if
        Alive == true -> ok;
        Alive == false -> terminate(Process, process_dead)
    end.


terminate(Process) ->
    exit(Process, normal),
    exit(normal).

terminate(Process, Reason) ->
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
    Super ! { self(), finished },
    exit(normal).


as_bad_protocol(Super) ->
    Super ! { self(), bad_protocol },
    exit(bad_protocol).
