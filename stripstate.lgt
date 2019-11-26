:- object(stripstate,
    imports(situation_query),
    implements(situation_protocol)).

    :- info([ version is 1.1
            , author is 'Paul Brown'
            , date is 2019/11/2
            , comment is 'A situation is defined by the fluents it contains.'
            ]).


    empty([]).

    do(A, S1, S2) :-
        ^^is_action(A),
        A::do(S1, S2).

    :- meta_predicate(holds_(*, *)).
    holds_(F, S) :-
        % Is a Fluent Case
        ^^is_fluent(F),
        F::holds(S).
    holds_(F, S) :-
        % Maybe it's in the situation list
        \+ ^^is_fluent(F),
        list::member(F, S).
    holds_(Ob::Pred, S) :-
        % Maybe it's an object fluent
        is_obj_fluent(Ob::Pred),
        call(Ob::Pred, S).
    holds_(F, S) :-
        % Is not a Fluent, treat as term
        nonvar(F),
        \+ ^^is_fluent(F),
        \+ list::memberchk(F, S),
        \+ is_obj_fluent(F),
        catch(call(F), error(existence_error(procedure, _), _), fail).

    is_obj_fluent(Ob::Pred) :-
        current_object(Ob),
        Ob::current_predicate(fluent/1),
        Ob::fluent(Func/Ar),
        SAr is Ar - 1,
        functor(Pred, Func, SAr).

    :- public(poss/2).
    :- mode(poss(+object, +list), zero_or_one).
    :- mode(poss(-object, +list), zero_or_more).
    :- info(poss/2,
        [ comment is 'True iff. Action is an action and it is possible in the situation.'
        , argnames is ['Action', 'Situation']
        ]).
    poss(A, S) :-
        ^^is_action(A),
        A::poss(S).

:- end_object.
