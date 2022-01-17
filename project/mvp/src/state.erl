-module(state).
-export([
    empty/0,
    add/2,
    add/3,
    get/2,
    remove/2
]).

empty() -> [].

add(Key, Value) ->
    add(Key, Value, []).

add(Key, Value, State) ->
    State_1 = remove(Key, State),
    [{Key, Value} | State_1].


get(Key, State) ->
    get(Key, [], State).

get(Key, Searched, [This | Unsearched]) ->
    case This of
        { Key, Value } -> Value;
        { _Other, _V } -> get(Key, [This | Searched], Unsearched)
    end;

get(_Key, _Searched, []) ->
    { none, none }.


remove(Key, State) ->
    remove(Key, [], State).

remove(Key, Searched, [This | Unsearched]) ->
    case This of
        { Key, _ } -> remove(Key, Searched, Unsearched);
        _          -> remove(Key, [This | Searched], Unsearched)
    end;

remove(_Key, Searched, []) ->
    Searched.
