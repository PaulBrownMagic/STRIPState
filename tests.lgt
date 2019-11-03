:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.2,
		author is 'Paul Brown',
		date is 2020/10/28,
		comment is 'Unit tests for tictactoe.'
	]).

    cover(fluent).
    cover(action).
    cover(stripstate).

    s0([door_position(closed), power(light, off)]).

    % Test fluents
    test(holds_in_s0, true(P == closed)) :-
        s0(S),
        door_position(P)::holds(S).
    test(fails_in_s0, fail) :-
        s0(S),
        door_position(open)::holds(S).

    test(holds_on_action, true([D, V] == [light, on])) :-
        s0(S), turn_on(light)::do(S, S1),
        power(D, V)::holds(S1).
    test(actions_clobber, fail) :-
        s0(S), turn_on(light)::do(S, S1), turn_off(light)::do(S1, S2),
        power(light, on)::holds(S2).

    % Test actions
    test(poss_in_s0, true) :-
        s0(S),
        ^^assertion(open_door::poss(S)),
        ^^assertion(turn_on(light)::poss(S)).
    test(poss_after_actions, true) :-
        s0(S), open_door::do(S, S1), turn_on(light)::do(S1, S2),
        close_door::poss(S2),
        turn_off(light)::poss(S2).

    test(doing_action_asserts, true(list::member(door_position(open), S))) :-
        s0(S0),
        open_door::do(S0, S).
    test(doing_action_retracts, true(\+ list::member(door_position(closed), S))) :-
        s0(S0),
        open_door::do(S0, S).
    test(cant_do_action, fail) :-
        s0(S0),
        close_door::do(S0, _).

    test(plain_holds, true(P == closed)) :-
        s0(S0),
        stripstate::holds(door_position(P), S0).
    test(query_holds, true([P, V] == [closed, off])) :-
        s0(S0),
        stripstate::holds(door_position(P) and power(light, V), S0).
    test(term_holds, true(X = 3)) :-
        stripstate::holds(X is 1 + 2, []).
    test(term_holds_builtin, true(Ls = [a, b, c])) :-
        findall(X, stripstate::holds(list::member(X, [a, b, c]), []), Ls).
    test(term_holds_other_object, true) :-
        s0(S0),
        stripstate::holds(open_door::poss(S0), []).
    test(term_holds_backend, true(C = 97)) :-
        stripstate::holds({char_code(a, C)}, []).

    test(sit_poss, true) :-
        s0(S0),
        stripstate::poss(open_door, S0).

:- end_object.
