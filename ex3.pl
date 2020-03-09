:- dynamic min/1.
:- dynamic pass/1.
:- dynamic o/2.
:- dynamic h/2.
:- dynamic jump/1.
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
    X < 10,
    Y < 10,
    Y >= 0,
    \+ o(X,Y).

chek_back(X,Y,Move,X_new1, X_new2, Y_new1, Y_new2) :-
    (Move='right'    ->X_new1 is X-1, X_new2 is X_new1, Y_new1 is Y-1, Y_new2 is Y+1;
        (Move='left'  ->X_new1 is X+1, X_new2 is X_new1, Y_new1 is Y-1, Y_new2 is Y+1;
            (Move='up' ->X_new1 is X+1, X_new2 is X-1, Y_new1 is Y-1, Y_new2 is Y-1;
                (Move='down'  ->X_new1 is X+1, X_new2 is X-1, Y_new1 is Y+1, Y_new2 is Y+1;
                    (Move='pass_d'->X_new1 is -1, X_new2 is -1, Y_new1 is -1, Y_new2 is -1;
                        (Move='pass_v'->X_new1 is -1, X_new2 is -1, Y_new1 is -1, Y_new2 is -1;
                         (Move='pass_g'->X_new1 is -1, X_new2 is -1, Y_new1 is -1, Y_new2 is -1;true))))))).


dfs(X,Y, _, [],K) :-
    t(X,Y),
    retractall(min(_)),
    (pass(1)->K1 is K-1;K1 is K),
    assert(min(K1)).


dfs(X,Y, History, [[Move,(X_new,Y_new)]|Moves],K) :-
    (X1 is X+1, t(X1,Y)-> 'right' = Move;
        (X1 is X-1, t(X1,Y)-> 'left'=Move; 
            (Y1 is Y-1, t(X,Y1)-> 'down'= Move;
              (Y1 is Y+1, t(X,Y1)->'up' = Move;
                (X1 is X+2, t(X1,Y), X2 is X+1, \+ o(X2,Y)-> 'right' = Move;
                 (Y1 is Y+2, t(X,Y1), Y2 is Y+1, \+ o(X,Y2)-> 'up' = Move;
                     (X1 is X-2, t(X1,Y), X2 is X-1, \+ o(X2,Y)-> 'left' = Move;
                        (Y1 is Y-2, t(X,Y1), Y2 is Y-1, \+ o(X,Y2)-> 'down' = Move;true)))))))),
    update(X,Y, Move, X_new, Y_new),
    retractall(jump(1)),
    legal(X_new, Y_new),    
    \+ member((X_new, Y_new), History),
    K1 is K + 1,
    min(M),
    K<M,
    chek_back(X,Y,Move,X_new1, X_new2 ,Y_new1,Y_new2),

    dfs(X_new, Y_new, [(X_new,Y_new),(X_new1,Y_new1),(X_new2,Y_new2)|History], Moves,K1).

print([]).
print([[Move,(X_new,Y_new)]|Moves]) :-
    (Move = 'pass_d';Move = 'pass_v';Move = 'pass_g' -> write("P ");true),
    write(X_new), write(" "), write(Y_new),nl,
    print(Moves).



solve_problem(Input) :-
    consult(Input),
    set_prolog_flag(answer_write_options,[max_depth(0)]),
    statistics(runtime, [T0|_]),
    assert(min(1000)),    
    initial_state(X,Y),
    findall(Solution,dfs(X,Y, [(X,Y)], Solution,0),L),
    last(L,Last),
    length(Last,V),
    write(V),nl,
    print(Last),
    statistics(runtime, [T1|_]), 
   T2 is T1 - T0,
   T is T2*1000,
   format('took ~3d msec.~n', [T]).