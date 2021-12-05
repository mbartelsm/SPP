-module(test02).
-export([start/0, offense_of/1, defense_of/1]).

start() ->
    fight(
        new_navy(10,2,6,4),
        new_navy(18,8,6,4)
    ).

sum_with(Func, List) ->
    lists:foldr(fun(Elem, Sum) -> Func(Elem) + Sum end, 0, List).

new_ship(Offense, Defense, Hp) -> {Offense, Defense, Hp}.


new_navy(Offense, Defense, Hp, Count) ->
    lists:duplicate(Count, new_ship(Offense, Defense, Hp)).


offense_of({Offense, _Defense, _Hp}) -> Offense;
offense_of(List) -> offense_of(List, 0).

offense_of([], Acc) -> Acc;
offense_of([Ship|Ships], Acc) -> offense_of(Ships, offense_of(Ship) + Acc).


defense_of({_Offense, Defense, _Hp}) -> Defense;
defense_of(List) -> defense_of(List, 0).

defense_of([], Acc) -> Acc;
defense_of([Ship|Ships], Acc) -> defense_of(Ships, defense_of(Ship) + Acc).


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
    OffenseA = sum_with(fun(X) -> offense_of(X) end, SideA),
    OffenseB = sum_with(fun(X) -> offense_of(X) end, SideB),
    DefenseA = sum_with(fun(X) -> defense_of(X) end, SideA),
    DefenseB = sum_with(fun(X) -> defense_of(X) end, SideB),

    ResultsA = max(OffenseB - DefenseA, 0),
    ResultsB = max(OffenseA - DefenseB, 0),

    fight(damage(SideA, ResultsA), damage(SideB, ResultsB)).
