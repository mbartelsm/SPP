-module(main).
-export([main/0]).

main() ->
    trader:init(state:empty()).
