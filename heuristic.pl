:- dynamic min/1.
:- dynamic pass/1.
:- dynamic o/2.
:- dynamic h/2.
:- dynamic t/2.
initial_state( 0,0 ).


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
    not(pass(0)),
    h(X,Y_any),
    not(is_org_g(X,Y,Y_any)),
    Y_new is Y_any.

% VERTICAL PASS
update(  X,Y, pass_v, X_new, Y) :-
    not(pass(0)),
    h(X_any,Y),
    not(is_org_v(X,X_any,Y)),
    X_new is X_any.

% DIAGONAL PASS
update( X,Y, pass_d, X_new,Y_new) :-
    not(pass(0)),
    h(X_any,Y_any),
    D  is X_any - X,
    D1 is Y_any - Y,
    D=D1,
    not(is_org_d(X,Y,D)),
    X_new is X_any,
    Y_new is Y_any.

update( X,Y, pass_d, X_new,Y_new) :-
    not(pass(0)),
    h(X_any,Y_any),
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
    X < 8,
    Y < 8,
    Y >= 0,
    \+ o(X,Y).


prolong([[X,Y]|Tail],[[X_new,Y_new],[X,Y]|Tail]):-
    update(X,Y,_,X_new,Y_new),not(member([X_new,Y_new],[[X,Y]|Tail])),legal(X_new,Y_new).


bfs([[[X,Y]|Tail]|_],[[X,Y]|Tail]):-
t(X,Y).
bfs([TempWay|OtherWays],Way):-
    findall(W,prolong(TempWay,W),Ways),
    append(OtherWays,Ways,NewWays),
    bfs(NewWays,Way).
 
print([]).
print([[X_new,Y_new]|Moves]) :-
    print(Moves), write(X_new), write(" "), write(Y_new),nl.
   


letsplay(Input) :-
    consult(Input),
    statistics(runtime, [T0|_]),   
    bfs([[[0,0]]],Way),
    length(Way,V),
    write(V),nl,
    print(Way),
    statistics(runtime, [T1|_]), 
    T is T1 - T0,
    format('took ~3d sec.~n', [T]),!.