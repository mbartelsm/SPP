%% Module containing the logic to execute and communicate with a supervisor
-module(super).
-export([
    init/2,
    send_msg/3,
    get_msg/1,
    get_msg_from/2,
    as_finished/1,
    as_bad_protocol/1
]).


%% Initializes the supervisor
%% The supervisor then uses the provided function to initialize the process it 
%% will monitor.
init(Function, Network) ->
    Self = self(),
    log:debug(?MODULE, "Starting supervisor at ~w", [Self]),

    % Add self to network dictionary
    NewNetwork = state:add(super, Self, Network),

    % Spawn process with the expanded dictionary
    Process = spawn(fun () -> Function(NewNetwork) end),
    log:debug(?MODULE, "Starting process at ~w", [Process]),
    supervise(Process).


%% Pipes messages through and from the supervised process while also monitoring
%% it to ensure it remains alive.
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


%% Performs actions in case the process changes state
handle_state(Process, Request) ->
    case Request of
        finished -> terminate(Process);
        bad_protocol -> terminate(Process, bad_protocol);
        Other -> terminate(Process, Other)
    end.


%% Checks that the given process is still alive, else terminates self.
ping_or_exit(Process) ->
    Alive = is_process_alive(Process),
    if
        Alive == true -> ok;
        Alive == false -> terminate(Process, process_dead)
    end.


%% Terminates self and, if possible, the supervised process normally
terminate(Process) ->
    log:warn(?MODULE_STRING, "terminating ~w with ~w", [self(), normal]),
    exit(Process, normal),
    exit(normal).

%% Terminates self and, if possible, the supervised process with the specified
%% termination reason
terminate(Process, Reason) ->
    log:warn(?MODULE_STRING, "terminating ~w with ~w", [self(), Reason]),
    exit(Process, Reason),
    exit(Reason).


%% Sends a message to the supervisor
send_msg(Super, Dest, Msg) ->
    Super ! { self(), Dest, Msg }.


%% Gets a message from the supervisor
get_msg(Super) ->
    receive
        { Super, Sender, Msg } -> { Sender, Msg }
    end.


%% Gets a message from the supervisor that was sent by the specified process
get_msg_from(Super, Sender) ->
    receive
        { Super, Sender, Msg } -> { Sender, Msg }
    end.


%% Informs the supervisor of normal termination
as_finished(Super) ->
    log:warn(?MODULE_STRING, "finished ~w", [self()]),
    Super ! { self(), finished },
    exit(normal).


%% Informs the supervisor of termination due to a bad protocol
as_bad_protocol(Super) ->
    Super ! { self(), bad_protocol },
    exit(bad_protocol).
