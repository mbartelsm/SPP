-module(test02).
-export([
    new_navy/4,
    fight/2
]).

sum_with(Func, List) ->
    lists:foldl(fun(Elem, Sum) -> Func(Elem) + Sum end, 0, List).

new_ship(Offense, Defense, Hp) -> {Offense, Defense, Hp}.

new_navy(Offense, Defense, Hp, Count) ->
    lists:duplicate(Count, new_ship(Offense, Defense, Hp)).

offense_of({Offense, _Defense, _Hp}) -> Offense.

defense_of({_Offense, Defense, _Hp}) -> Defense.

hp_of({_Offense, _Defense, Hp}) -> Hp.

hp_for(Ship, NewHp) -> new_ship(offense_of(Ship), defense_of(Ship), NewHp).

damage([], _Damage) -> [];
damage([Ship|Ships], Damage) ->
    Hp = hp_of(Ship),
    if
        Hp > Damage  -> [hp_for(Ship, Hp - Damage)|Ships];
        Hp =< Damage -> damage(Ships, Damage - Hp)
    end.

fight([], []) -> {none, []};
fight(SideA, []) -> {a, SideA};
fight([], SideB) -> {b, SideB};
fight(SideA, SideB) ->
    OffenseA = sum_with(fun offense_of/1, SideA),
    OffenseB = sum_with(fun offense_of/1, SideB),

    DefenseA = sum_with(fun defense_of/1, SideA),
    DefenseB = sum_with(fun defense_of/1, SideB),

    ResultsA = max(OffenseB - DefenseA, 0),
    ResultsB = max(OffenseA - DefenseB, 0),

    fight(damage(SideA, ResultsA), damage(SideB, ResultsB)).
