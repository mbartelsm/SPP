-module(heathrow).
-export([shortest_path/1]).


shortest_path(List) -> shortest_path(List, [], []).

shortest_path([], PathA, PathB) ->
    LenA = len(PathA),
    LenB = len(PathB),
    if
        LenA <  LenB -> lists:reverse(PathA);
        LenA >= LenB -> lists:reverse(PathB)
    end;

shortest_path([{A, B, X}|List], PathA, PathB) ->
    LenA = len(PathA),
    LenB = len(PathB),
    NewPathA = if
        LenA + A =< LenB + B + X -> [{a,A} | PathA];
        LenA + A >  LenB + B + X -> [{x,X}, {b,B} | PathB]
        end,
    NewPathB = if
        LenB + B =< LenA + A + X -> [{b,B} | file:open(A)];
        LenB + B >  LenA + A + X -> [{x,X}, {a,A} | PathA]
        end,
    shortest_path(List, NewPathA, NewPathB).

len(List) -> lists:foldl(fun({_,A}, B) -> A + B end, 0, List).
