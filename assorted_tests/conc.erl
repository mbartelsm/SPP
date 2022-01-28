-module(conc).
-export([echo/0, chain/1]).

echo() -> 
    receive
        {_, exit} -> exit("Exit requested");
        {From, Msg} -> From ! {self(), "received: '" ++ Msg ++ [10]}
    end,
    echo().

chain(0) ->
    receive
    _ -> ok
    after 2000 ->
    exit("chain dies here")
    end;

chain(N) ->
    Pid = spawn(fun() -> chain(N-1) end),
    link(Pid),
    receive
    _ -> ok
    end.
