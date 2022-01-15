-module(super).
-export([
    init/1,
    pipe_msg/3,
    make_req/2
]).


init(Function) ->
    Process = spawn(Function),
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
            handle_request(Msg);

        % From outside to process
        { Sender, Msg } ->
            ping_or_exit(Process),
            Process ! { self(), Sender, Msg }

    after
        100000 -> terminate(Process, timeout)
    end,
    
    supervise(Process).


handle_request(_Request) ->
    ok.


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


pipe_msg(Super, Dest, Msg) ->
    Super ! { self(), Dest, Msg }.


make_req(Super, Request) ->
    Super ! { self(), Request }.
