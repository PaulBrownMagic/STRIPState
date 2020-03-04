:- category(fluent,
    implements(fluent_protocol)).

    :- info([ version is 1:2:0
            , author is 'Paul Brown'
            , date is 2019-11-03
            , comment is 'A fluent predefines holds/1 as a fluent in the situation term.'
            ]).

    holds(S) :-
       self(Self),
       list::member(Self, S).
:- end_category.
