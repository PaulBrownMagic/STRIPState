/*
In this example we have a door and a light to work with.

Example queries:

```

?- stripstate::holds(door_position(Pos) and power(light, Power), [door_position(closed), power(light, off)]).
Pos = closed,
Power = off ;
false.

?- stripstate::poss(A, [door_position(closed), power(light, off)]).
A = turn_on(light) ;
A = open_door ;
false.

?- open_door::do([door_position(closed), power(light, off)], S1).
S1 = [door_position(open), power(light, off)].

?- turn_on(light)::do($(S1), S2).
S2 = [door_position(open), power(light, on)],
S1 = [door_position(open), power(light, off)].

?- stripstate::holds(F, $(S2)), F::holds($(S1)).
F = door_position(open),
S2 = [door_position(open), power(light, on)],
S1 = [door_position(open), power(light, off)] ;
false.
```
*/

:- object(power(_Dev_, _V_), imports(fluent)).
:- end_object.

:- object(door_position(_Pos_), imports(fluent)).
:- end_object.

:- object(turn_on(_Dev_), imports(action)).
    poss(S) :-
        power(_Dev_, off)::holds(S).
    retract_fluents([power(light, off)]).
    assert_fluents([power(light, on)]).
:- end_object.

:- object(turn_off(_Dev_), imports(action)).
   poss(S) :-
       power(_Dev_, on)::holds(S).
    retract_fluents([power(light, on)]).
    assert_fluents([power(light, off)]).
:- end_object.

:- object(open_door, imports(action)).
    poss(S) :-
        door_position(closed)::holds(S).
    retract_fluents([door_position(closed)]).
    assert_fluents([door_position(open)]).
:- end_object.

:- object(close_door, imports(action)).
    poss(S) :-
        door_position(open)::holds(S).
    retract_fluents([door_position(open)]).
    assert_fluents([door_position(closed)]).
:- end_object.
