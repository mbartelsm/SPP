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

report(Level, Module, Message, Arguments) when is_list(Arguments) ->
    LevelString = case Level of
        debug -> "DEBUG";
        info ->  "INFO";
        warn ->  "WARN";
        error -> "ERROR"
    end,
    FullMessage = lists:flatten(io_lib:format(Message, Arguments)),
    io:fwrite("[~s] ~s :: ~s ~n", [LevelString, Module, FullMessage]).


debug(Module, Message) -> debug(Module, Message, []).
debug(Module, Message, Arguments) ->
    OsLevel = state:get("ERL_LEVEL", os:env()),

    if
        OsLevel == "debug" -> report(debug, Module, Message, Arguments);
        OsLevel /= "debug" -> ok
    end.

info(Module, Message) -> info(Module, Message, []).
info(Module, Message, Arguments) ->
    OsLevel = state:get("ERL_LEVEL", os:env()),
    
    if
        (OsLevel == "info") 
        or (OsLevel == "debug") -> report(info, Module, Message, Arguments);
        true -> ok
    end.

warn(Module, Message) -> warn(Module, Message, []).
warn(Module, Message, Arguments) ->
    OsLevel = state:get("ERL_LEVEL", os:env()),
    
    if
        (OsLevel == "warn")
        or (OsLevel == "info")
        or (OsLevel == "debug") -> report(warn, Module, Message, Arguments);
        true -> ok
    end. 

error(Module, Message) -> ?MODULE:error(Module, Message, []).
error(Module, Message, Arguments) ->
    OsLevel = state:get("ERL_LEVEL", os:env()),
    
    if
        (OsLevel == "error")
        or (OsLevel == "warn")
        or (OsLevel == "info")
        or (OsLevel == "debug") -> report(error, Module, Message, Arguments);
        true -> ok
    end. 
