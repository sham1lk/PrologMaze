:- dynamic min/1.
:- dynamic passdone.
initial_state( 0,0 ).
f(8,5).
f(9,9).

o(0,1).
o(0,2).
o(0,3).
o(0,4).
o(0,5).
o(0,6).
o(0,7).
o(0,8).
o(0,9).
o(1,0).
o(2,0).
o(3,0).
o(3,1).
o(3,2).
o(3,3).
o(2,3).

p(1,1).
p(1,8).
p(6,8).



% RIGHT
update(  X, Y, right, X_new, Y  ) :-
    X_new is X + 1.

% LEFT
update( X,Y, left, X_new, Y ) :-
    X_new is X - 1.

% DOWN
update(  X,Y, down, X, Y_new  ) :-
    Y_new is Y - 1.

% UP
update(  X,Y, up, X, Y_new  ) :-
    Y_new is Y + 1.

% GORESONTAL PASS
update(  X,Y, pass_g, X, Y_new) :-
    p(X,Y_any),
    not(is_org_g(X,Y,Y_any)),
    Y_new is Y_any.

% VERTICAL PASS
update(  X,Y, pass_v, X_new, Y) :-
    p(X_any,Y),
    not(is_org_v(X,X_any,Y)),
    X_new is X_any.

% DIAGONAL PASS
update( X,Y, pass_d, X_new,Y_new) :-
    p(X_any,Y_any),
    D  is X_any - X,
    D1 is Y_any - Y,
    D=D1,
    not(is_org_d(X,Y,D)),
    X_new is X_any,
    Y_new is Y_any.

update( X,Y, pass_d, X_new,Y_new) :-
    p(X_any,Y_any),
    D  is X_any - X,
    D1 is Y - Y_any,
    D=D1,
    not(is_org_d1(X,Y,D)),
    X_new is X_any,
    Y_new is Y_any.


is_org_d1(X,Y,D) :-
    between(0,D,K),
    X1 is X+K,
    Y1 is Y-K,
    o(X1,Y1),!.

is_org_d(X,Y,D) :-
    between(0,D,K),
    X1 is X+K,
    Y1 is Y+K,
    o(X1,Y1),!.

is_org_v(X,X1,Y) :-
    between(X,X1,K),
    o(K,Y),!.


is_org_g(X,Y,Y1) :-
    between(Y,Y1,K),
    o(X,K),!.


legal( X,Y ) :-
    X >= 0,
    X < 10,
    Y < 10,
    Y >= 0,
    \+ o(X,Y).


dfs(X,Y, _, [],K) :-
    f(X,Y),
    retractall(min(_)),
    assert(min(K)).

dfs(X,Y, History, [[Move,(X_new,Y_new)]|Moves],K) :-
    update(X,Y, Move, X_new, Y_new),
    legal(X_new, Y_new),
    \+ member((X_new, Y_new), History),
    K1 is K + 1,
    min(M),
    K<M,
    dfs(X_new, Y_new, [(X_new,Y_new)|History], Moves,K1).


solve_problem(Last) :-
    set_prolog_flag(answer_write_options,[max_depth(0)]),
    assert(min(1000)),    
    initial_state(X,Y),
    findall(Solution,dfs(X,Y, [(X,Y)], Solution,0),L),
    last(L,Last).