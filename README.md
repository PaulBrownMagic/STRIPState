# STRIPState


STRIPState is a framework for managing state in an application without
mutation based on STRIPS and situation calculus.

![Workflow Status](https://github.com/PaulBrownMagic/STRIPState/workflows/Workflow/badge.svg)
[Code Coverage Report](https://paulbrownmagic.github.io/STRIPState/coverage_report.html)

In this library a situation is a list of fluents that hold in that state.

```logtalk
[power(kettle, on), temp(water, cold), broken(heating_element)]
```

This list is what is passed around your application.

To change this list, you *should* only do so through actions, which
extend the action class:

```logtalk
:- object(drop(_Item_),
    extends(action)).

    poss(Situation) :-
        holding(_Item_)::holds(Situation).

	retracts_fluents([holding(_Item_)]).
	asserts_fluents([]).

:- end_object.
```

This describes a drop action that is only possible when holding the
item. All actions must have possible conditions, even if they're just
always possible: `poss(_).`

An action is done like so:

```logtalk

?- Sit = [holding(ball)], drop(ball)::do(Sit, NextSit).
```

The values that change in the application are called fluents (because
of the situation calculus influence). We need to define in what situations they
hold with what values. Most of the time, this will just be if that
fluent is a member of the situation list. In these cases you only need
to declare the fluent. Note, in Logtalk the objects are identified by
their functors.

```logtalk
:- object(holding(_Item_),
    extends(fluent)).
:- end_object.
```

Should the fluent be derived from others, this can be declared like so:

```logtalk
:- object(net_profit(_Profit_),
    extends(fluent)).

	holds(S) :-
	    gross_profit(P)::holds(S),
	    total_costs(C)::holds(S),
		_Profit_ is P - C.

:- end_object.
```

We can query them like so:

```logtalk
?- holding(What)::holds([holding(pen)]).
What = pen.

?- S = [holding(pen)], pick_up(ball)::do(S, S1), holding(What)::holds(S1).
What = ball ;
What = pen.

?- drop(pen)::do($(S1), S2), holding(What)::holds(S2).
What = ball.
```

Finally, the situation object has a couple of utility predicates:

```logtalk
?- situation::poss(A, []).
A = pick_up(ball).

?- situation::holds(holding(pen) and holding(ball), [holding(pen), holding(ball)]).
true.
```

The `holds/2` predicate on the situation object is quite different, it
also contains query composition operators: `and`, `or`, `not`,
`implies`, and `equivalentTo`. These are transformed via the revised
Lloyd Topper transformations from Reiter, and then the individual
fluents or other goals are called. This is useful when defining `poss/1`
for actions:

```logtalk
:- object(boil_kettle,
    extends(action)).

	poss(S) :-
	    situation::holds(power(kettle, on) and not kettle_water(empty), S).

:- end_object.
```

As we're in Prolog, `not` has the same meaning as `\+`.

Finally, to persist a situation between sessions, persist the list of
fluents and reload. This method of state handling clobbers it's history
of events. Should this be important for your application, consider using
[SitCalc](https://github.com/PaulBrownMagic/SitCalc) instead.
