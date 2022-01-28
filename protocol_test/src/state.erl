%% A module providing a simple lookup table
%% The implementation uses tagged tuples on a list
-module(state).
-export([
    empty/0,
    add/2,
    add/3,
    get/2,
    remove/2
]).

%% Creates an empty dictionary
empty() -> [].


%% Creates a new dictionary with the provided key-value pair
add(Key, Value) ->
    add(Key, Value, []).


%% Adds the provided key-value pair to the dictionary
add(Key, Value, State) ->
    State_1 = remove(Key, State),
    [{Key, Value} | State_1].


%% Gets the value of the provided key, if available. Returns { none, none }
%% if the key is not found in the dictionary.
get(Key, State) ->
    get(Key, [], State).

get(Key, Searched, [This | Unsearched]) ->
    case This of
        { Key, Value } -> Value;
        { _Other, _V } -> get(Key, [This | Searched], Unsearched)
    end;

get(_Key, _Searched, []) ->
    { none, none }.


%% Removes the given keyfrom the dictionary, if found.
%% This does NOT return the value of the removed key.
remove(Key, State) ->
    remove(Key, [], State).

remove(Key, Searched, [This | Unsearched]) ->
    case This of
        { Key, _ } -> remove(Key, Searched, Unsearched);
        _          -> remove(Key, [This | Searched], Unsearched)
    end;

remove(_Key, Searched, []) ->
    Searched.
