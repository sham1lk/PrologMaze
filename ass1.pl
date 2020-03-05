
:-dynamic ([
	org_location/1,
	tuch_location/1,
	ball_location/1,
	visited/1]).

start :- 
	generate_map,
	game.

generate_map :-
	assert(org_location([3,0])),
	assert(tuch_location([5,1])),
	assert(ball_location([0,0])),
	assert(visited([0,0])).
game :-
	ball_location(BL),
	format('I\'m in ~p~n', [BL]),
	move_right,
	move_left,
	move_up,
	move_down.
	
move_right :- 
	ball_location([X,Y]),
	X1 is X+1,
	visited(VL),
	(not(org_right), @<(X,20), \+member([X1,Y],[VL])->
		move_to_right;
		true).

move_to_right :-
	ball_location([P1,P2]),
	retractall( ball_location(_) ),
    P3 is P1+1,
    assert( ball_location([P3,P2]) ),
    assert(visited([P3,P2])),
    game.

org_right :-
	ball_location([X1,Y1]),
	org_location(X),
	X2 is X1+1,
	member([X2,Y1],[X]).



move_left :- 
	ball_location([X,Y]),
	X1 is X-1,
	visited(VL),
	(not(org_left), @>(X,0), \+(member([X1,Y],[VL])) ->
		move_to_left).

move_to_left :-
	ball_location([P1,P2]),
	retractall( ball_location(_) ),
    P3 is P1-1,
    assert( ball_location([P3,P2]) ),
    assert(visited([P3,P2])),
    game.

org_left :-
	ball_location([X1,Y1]),
	org_location(X),
	X2 is X1-1,
	member([X2,Y1],[X]).




move_up :- 
	ball_location([X,Y]),
	Y1 is Y+1,
	visited(VL),
	(not(org_up), @<(Y,20), not(is_member([X,Y1],[VL])) ->
		move_to_up).

move_to_up :-
	format('Up ~n'),
	ball_location([P1,P2]),
	retractall( ball_location(_) ),
    P3 is P2+1,
    assert( ball_location([P1,P3]) ),
    assert(visited([P1,P3])),
    game.

org_up :-
	ball_location([X1,Y1]),
	org_location(X),
	Y2 is Y1+1,
	member([X1,Y2],[X]).


move_down :- 
	ball_location([X,Y]),
	Y1 is Y-1,
	visited(VL),
	(not(org_down), @>(Y,0), not(is_member([X,Y1],[VL])) ->
		move_to_down).

move_to_down :-
	ball_location([P1,P2]),
	retractall( ball_location(_) ),
    P3 is P2-1,
    assert( ball_location([P1,P3]) ),
    assert(visited([P1,P3])),
    game.

org_down :-
	ball_location([X1,Y1]),
	org_location(X),
	Y2 is Y1-11,
	member([X1,Y2],[X]).

is_member(A,B) :-
	member(A,B),!.