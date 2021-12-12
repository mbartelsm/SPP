-module(proc_test).
-export([
    spawn_short/0
    , spawn_long/0
    , spawn_endless/0
]).

countdown(0) -> done;
countdown(N) -> countdown(N-1).

loop() -> loop().

spawn_short() -> spawn(fun() -> countdown(1) end).

spawn_long() -> spawn(fun() -> countdown(10000000) end).

spawn_endless() -> spawn(fun() -> loop() end).