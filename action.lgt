:- category(action,
    implements(action_protocol)).

     :- info([ version is 1.2
             , author is 'Paul Brown'
             , date is 2019/11/3
             , comment is 'An action for STRIPSstate.'
             ]).

    :- public(retract_fluents/1).
    :- mode(retract_fluents(+list), one).
    :- info(retract_fluents/1,
        [ comment is 'A list of the fluents this action retracts from the situation.'
        , argnames is ['Fluents']
        ]).

    :- public(assert_fluents/1).
    :- mode(assert_fluents(+list), one).
    :- info(assert_fluents/1,
        [ comment is 'A list of the fluents this action asserts to the situation.'
        , argnames is ['Fluents']
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
        ::retract_fluents(RF),
        ::assert_fluents(AF),
        findall(F, (list::member(F, S), \+ list::memberchk(F, RF)), S1, AF).

:- end_category.
