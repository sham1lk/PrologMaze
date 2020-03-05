:- dynamic min/1.
:- dynamic visited/2.
initial_state( 0,0 ).
f(8,5).
f(9,9).

o(0,1).

p(1,1).
p(1,8).
p(6,8).



% RIGHT
update1(  X, Y, right, X_new, Y  ) :-
    X_new is X + 1,
    legal(X_new,Y),
    write("right to ("), write(X_new), write(","), write(Y), write_ln(")").

% LEFT
update2( X,Y, left, X_new, Y ) :-
    X_new is X - 1,
    legal(X_new,Y).

% DOWN
update3(  X,Y, down, X, Y_new  ) :-
    Y_new is Y - 1,
    legal(X,Y_new).

% UP
update4(  X,Y, up, X, Y_new  ) :-
    Y_new is Y + 1,
    legal(X,Y_new).

% GORESONTAL PASS
update5(  X,Y, pass_g, X, Y_new) :-
    p(X,Y_any),
    not(is_org_g(X,Y,Y_any)),
    Y_new is Y_any,
    legal(X,Y_new).

% VERTICAL PASS
update6(  X,Y, pass_v, X_new, Y) :-
    p(X_any,Y),
    not(is_org_v(X,X_any,Y)),
    X_new is X_any,
    legal(X_new,Y).


% DIAGONAL PASS
update7( X,Y, pass_d, X_new,Y_new) :-
    p(X_any,Y_any),
    D  is X_any - X,
    D1 is Y_any - Y,
    D=D1,
    not(is_org_d(X,Y,D)),
    X_new is X_any,
    Y_new is Y_any,
    legal(X_new,Y_new).


update8( X,Y, pass_d, X_new,Y_new) :-
    p(X_any,Y_any),
    D  is X_any - X,
    D1 is Y - Y_any,
    D=D1,
    not(is_org_d1(X,Y,D)),
    X_new is X_any,
    Y_new is Y_any,
    legal(X_new,Y_new).



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

move(X,Y) :-
    f(X,Y).

move(X,Y) :-
    min(N),
    N1 is N + 1,
    (N>100->false;true),
    random(1,9,K),
    (K = 1 -> (update1(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 2 -> (update2(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 3 -> (update3(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 4 -> (update4(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 5 -> (update5(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 6 -> (update6(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 7 -> (update7(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true),
    (K = 8 -> (update8(X,Y, M, X_new, Y_new)->assert(visited(X_new,Y_new)),move(X_new,Y_new),retractall(min(_)),assert(min(N1)); move(X,Y));true).


solve_problem :-
    set_prolog_flag(answer_write_options,[max_depth(0)]),
    assert(min(0)),
    move(0,0).