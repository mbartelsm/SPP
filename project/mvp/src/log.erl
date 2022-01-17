-module(log).
-export([
    info/2,
    info/3,
    warn/2,
    warn/3,
    error/2,
    error/3
]).

report(Level, Module, Message, Arguments) when is_list(Arguments) ->
    LevelString = case Level of
        info ->  "INFO";
        warn ->  "WARN";
        error -> "ERROR"
    end,
    FullMessage = lists:flatten(io_lib:format(Message, Arguments)),
    io:fwrite("[~s] ~s :: ~s ~n", [LevelString, Module, FullMessage]).


info(Module, Message) ->             report(info, Module, Message, []).
info(Module, Message, Arguments) ->  report(info, Module, Message, Arguments).

warn(Module, Message) ->             report(warn, Module, Message, []).
warn(Module, Message, Arguments) ->  report(warn, Module, Message, Arguments).

error(Module, Message) ->            report(error, Module, Message, []).
error(Module, Message, Arguments) -> report(error, Module, Message, Arguments).
