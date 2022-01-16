-module(state).
-export([
    set_val/2,
    set_val/3,
    get_val/2,
    remove_key/2
]).


set_val(Key, Value) ->
    set_val(Key, Value, []).

set_val(Key, Value, State) ->
    State_1 = remove_key(Key, State),
    [{Key, Value} | State_1].


get_val(Key, State) ->
    get_val(Key, [], State).

get_val(Key, Searched, [This | Unsearched]) ->
    case This of
        { Key, Value } -> Value;
        { _Other, _V } -> get_val(Key, [This | Searched], Unsearched)
    end;

get_val(_Key, _Searched, []) ->
    { none, none }.


remove_key(Key, State) ->
    remove_key(Key, [], State).

remove_key(Key, Searched, [This | Unsearched]) ->
    case This of
        { Key, _ } -> remove_key(Key, Searched, Unsearched);
        _          -> remove_key(Key, [This | Searched], Unsearched)
    end;

remove_key(_Key, Searched, []) ->
    Searched.
