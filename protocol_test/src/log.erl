%% A logging module with very basic output facilities
%% Output printing relies on environment variables
-module(log).
-export([
    debug/2,
    debug/3,
    info/2,
    info/3,
    warn/2,
    warn/3,
    error/2,
    error/3
]).


%% Common printing facility
report(LevelString, Module, Message, Arguments) when is_list(Arguments) ->
    FullMessage = lists:flatten(io_lib:format(Message, Arguments)),
    io:fwrite("[~s] ~w ~s :: ~s ~n", [LevelString, self(), Module, FullMessage]).


%% Prints a debug message to the console
debug(Module, Message) -> debug(Module, Message, []).
debug(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 3 -> report("DEBUG", Module, Message, Arguments);
        true -> ok
    end.


%% Prints an info maessage to the console
info(Module, Message) -> info(Module, Message, []).
info(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 2 -> report("INFO", Module, Message, Arguments);
        true -> ok
    end.


%% Prints a warning message to the console
warn(Module, Message) -> warn(Module, Message, []).
warn(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 1 -> report("WARN", Module, Message, Arguments);
        true -> ok
    end. 


%% Prints an error message to the console
error(Module, Message) -> ?MODULE:error(Module, Message, []).
error(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 0 -> report("ERROR", Module, Message, Arguments);
        true -> ok
    end. 


%% Converts the string env variable to a numeric value
get_level() ->
    LevelStr = os:getenv("ERL_LEVEL"),
    case LevelStr of
        "warn" -> 1;
        "info" -> 2;
        "debug" -> 3;
        _ -> 0
    end. 
