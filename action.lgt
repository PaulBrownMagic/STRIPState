:- category(action,
    implements(action_protocol)).

     :- info([ version is 1:3:0
             , author is 'Paul Brown'
             , date is 2019-11-03
             , comment is 'An action for STRIPSstate.'
             ]).

    :- public(retract_assert/2).
    :- mode(retract_assert(+list, +list), one).
    :- info(retract_assert/2,
        [ comment is 'A list of the fluents this action retracts and a list of fluent this action asserts from the situation.'
        , argnames is ['RetractFluents', 'AssertFluents']
        ]).

    :- public(do/2).
    :- mode(do(+list, ?list), zero_or_one).
    :- mode(do(-list, +list), zero_or_one).
    :- mode(do(-list, -list), zero_or_more).
    :- info(do/2,
        [ comment is 'True if doing the action in S1 results in S2.'
        , argnames is ['S1', 'S2']
        ]).
    do(S, S1) :-
        ::poss(S),
        ::retract_assert(RF, AF),
        findall(F, (list::member(F, S), \+ list::member(F, RF)), S1, AF).

:- end_category.
