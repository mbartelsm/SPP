-module(useless).
-compile(export_all).
%% -export([add/2, hello/0, greet_and_add_two/1, greet_gender/2]).

add(A, B) ->
    A + B.

hello() ->
    io:format("Hello, World!~n").

greet_and_add_two(X) ->
    hello(),
    add(X, 2).

greet_gender(male, Name) ->
    io:format("Hello, Mr. ~s!~n", [Name]);

greet_gender(female, Name) ->
    io:format("Hello, Ms. ~s!~n", [Name]);

greet_gender(_, Name) ->
    io:format("Hello, Mx. ~s!~n", [Name]).

show_timestamp({ {Year, Month, Day}, {Hour, Minute, Second} })
    when
        1  =< Month,    12 >= Month,
        1  =< Day,      31 >= Day,
        0  =< Hour,     23 >= Hour,
        0  =< Minute,   59 >= Minute,
        0  =< Second,   59 >= Second ->
    io:format("~5.B-~2.B-~2.BT~2.B:~2.B:~2.B.000~n", [Year, Month, Day, Hour, Minute, Second]);

show_timestamp(_) ->
    io:format("Invalid date time~n").

zip(As, Bs) -> lists:reverse(zip(As, Bs, [])).

zip([], _, Res) -> Res;
zip(_, [], Res) -> Res;
zip([A|As], [B|Bs], Res) -> zip(As, Bs, [{A, B}|Res]).


qs([]) -> [];
qs([L|Ls]) ->
    {Smaller, Larger} = partition(L, Ls),
    qs(Smaller) ++ [L] ++ qs(Larger).


partition(P, Ls) -> partition(P, Ls, [], []).

partition(_, [], Smaller, Larger) -> {Smaller, Larger};
partition(P, [L|Ls], Smaller, Larger) ->
    if
        L =< P -> partition(P, Ls, [L|Smaller], Larger);
        L >  P -> partition(P, Ls, Smaller, [L|Larger])
    end.

get_by_name(Tuple, A) when is_tuple(Tuple) -> get_by_name([Tuple], A);

get_by_name([], A) -> {error, {not_found, A}};

get_by_name([{A, Data}|_Tail], [A]) -> {ok, Data};
get_by_name([{A, Data}|_Tail], [A|Path]) -> get_by_name(Data, Path);
get_by_name([_|Tail], Path) when is_list(Path) -> get_by_name(Tail, Path);

get_by_name([{A,Data}|_], A) -> {ok, Data};
get_by_name([_|Tail], A) -> get_by_name(Tail, A).
