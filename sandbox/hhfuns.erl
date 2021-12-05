-module(hhfuns).
-compile(export_all).

filter(L, P) ->
    filter(L, P, []).

filter([], _, Acc) ->
    lists:reverse(Acc);

filter([L|Ls], P, Acc) ->
    case P(L) of
        true  -> filter(Ls, P, [L|Acc]);
        false -> filter(Ls, P, Acc)
    end.


foldr([L|Ls], F) ->
    foldr(Ls, F, L).

foldr([], _, Acc) ->
    Acc;

foldr([L|Ls], F, Acc) ->
    foldr(Ls, F, F(L, Acc)).


foldl(Ls, F) ->
    foldr(lists:reverse(Ls), F).

foldl(Ls, F, Acc) ->
    foldr(lists:reverse(Ls), F, Acc).
