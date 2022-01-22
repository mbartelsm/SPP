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

report(LevelString, Module, Message, Arguments) when is_list(Arguments) ->
    FullMessage = lists:flatten(io_lib:format(Message, Arguments)),
    io:fwrite("[~s] ~w ~s :: ~s ~n", [LevelString, self(), Module, FullMessage]).


debug(Module, Message) -> debug(Module, Message, []).
debug(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 3 -> report("DEBUG", Module, Message, Arguments);
        true -> ok
    end.


info(Module, Message) -> info(Module, Message, []).
info(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 2 -> report("INFO", Module, Message, Arguments);
        true -> ok
    end.


warn(Module, Message) -> warn(Module, Message, []).
warn(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 1 -> report("WARN", Module, Message, Arguments);
        true -> ok
    end. 


error(Module, Message) -> ?MODULE:error(Module, Message, []).
error(Module, Message, Arguments) ->
    OsLevel = get_level(),
    if
        OsLevel >= 0 -> report("ERROR", Module, Message, Arguments);
        true -> ok
    end. 


get_level() ->
    LevelStr = os:getenv("ERL_LEVEL"),
    case LevelStr of
        "warn" -> 1;
        "info" -> 2;
        "debug" -> 3;
        _ -> 0
    end. 
