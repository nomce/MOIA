%Source: http://www.cpp.edu/~jrfisher/www/prolog_tutorial/5_3.html

:- dynamic board/1.
:- retractall(board(_)).
:- assert(board([_Z1,_Z2,_Z3,_Z4,_Z5,_Z6,_Z7,_Z8,_Z9,_Z10,_Z11,_Z12,_Z13,_Z14,_Z15,_Z16,_Z17,_Z18,_Z19,_Z20,_Z21,_Z22,_Z23,_Z24,_Z25])). 

%%%%%
%%  Generate possible marks on a free spot on the board.
%%  Use mark(+,+,-X,-Y) to query/generate possible moves (X,Y).
%%%%%
mark(Player, [X|_],1,1) :- var(X), X=Player.
mark(Player, [_,X|_],2,1) :- var(X), X=Player.
mark(Player, [_,_,X|_],3,1) :- var(X), X=Player.
mark(Player, [_,_,_,X|_],4,1) :- var(X), X=Player.
mark(Player, [_,_,_,_,X|_],5,1) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,X|_],1,2) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,X|_],2,2) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,X|_],3,2) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,X|_],4,2) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,X|_],5,2) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,X|_],1,3) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,X|_],2,3) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,X|_],3,3) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],4,3) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],5,3) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],1,4) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],2,4) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],3,4) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],4,4) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],5,4) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],1,5) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],2,5) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],3,5) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],4,5) :- var(X), X=Player.
mark(Player, [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],5,5) :- var(X), X=Player.

%%%%%
%%  Record a move: record(+,+,+).
%%%%%
record(Player,X,Y) :- 
   retract(board(B)), 
   mark(Player,B,X,Y),
   assert(board(B)).

%%%%%
%% Calculate the value of a position, o maximizes, x minimizes.
%%%%%
value(Board,100) :- win(Board,o), !.
value(Board,-100) :- win(Board,x), !.
value(Board,E) :- 
   findall(o,open(Board,o),MAX), 
   length(MAX,Emax),      % # lines open to o
   findall(x,open(Board,x),MIN), 
   length(MIN,Emin),      % # lines open to x
   E is Emax - Emin.

%%%%% 
%%  A winning line is ALREADY bound to Player. 
%%  win(+Board,+Player) is true or fail.
%%    e.g., win([P,P,P|_],P).  is NOT correct, because could bind 
%%%%%
win([Z1,Z2,Z3,Z4,Z5|_],P) :- Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,_,_,Z1,Z2,Z3,Z4,Z5|_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,_,_,_,_,_,_,_,Z1,Z2,Z3,Z4,Z5|_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Z1,Z2,Z3,Z4,Z5|_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Z1,Z2,Z3,Z4,Z5],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([Z1,_,_,_,_,Z2,_,_,_,_,Z3,_,_,_,_,Z4,_,_,_,_,Z5,_,_,_,_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,Z1,_,_,_,_,Z2,_,_,_,_,Z3,_,_,_,_,Z4,_,_,_,_,Z5,_,_,_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,Z1,_,_,_,_,Z2,_,_,_,_,Z3,_,_,_,_,Z4,_,_,_,_,Z5,_,_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,Z1,_,_,_,_,Z2,_,_,_,_,Z3,_,_,_,_,Z4,_,_,_,_,Z5,_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,_,Z1,_,_,_,_,Z2,_,_,_,_,Z3,_,_,_,_,Z4,_,_,_,_,Z5],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([Z1,_,_,_,_,_,Z2,_,_,_,_,_,Z3,_,_,_,_,_,Z4,_,_,_,_,_,Z5],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.
win([_,_,_,_,Z1,_,_,_,Z2,_,_,_,Z3,_,_,_,Z4,_,_,_,Z5,_,_,_,_],P) :-  Z1==P, Z2==P, Z3==P, Z4==P,  Z5==P.

%%%%%
%%  Move 
%%%%%
move(P,(1,1),[X1|R],[P|R]) :- var(X1).
move(P,(2,1),[X1,X2|R],[X1,P|R]) :- var(X2).
move(P,(3,1),[X1,X2,X3|R],[X1,X2,P|R]) :- var(X3).
move(P,(1,2),[X1,X2,X3,X4|R],[X1,X2,X3,P|R]) :- var(X4).
move(P,(2,2),[X1,X2,X3,X4,X5|R],[X1,X2,X3,X4,P|R]) :- var(X5).
move(P,(3,2),[X1,X2,X3,X4,X5,X6|R],[X1,X2,X3,X4,X5,P|R]) :- var(X6).
move(P,(1,3),[X1,X2,X3,X4,X5,X6,X7|R],[X1,X2,X3,X4,X5,X6,P|R]) :- var(X7).
move(P,(2,3),[X1,X2,X3,X4,X5,X6,X7,X8|R],[X1,X2,X3,X4,X5,X6,X7,P|R]) :- var(X8).
move(P,(3,3),[X1,X2,X3,X4,X5,X6,X7,X8,X9|R],[X1,X2,X3,X4,X5,X6,X7,X8,P|R]) :- var(X9).


%%%%%
%% Calculate the value of a position, o maximizes, x minimizes.
%%%%%
value(Board,100) :- win(Board,o), !.
value(Board,-100) :- win(Board,x), !.
value(Board,E) :- 
   findall(o,open(Board,o),MAX), 
   length(MAX,Emax),      % # lines open to o
   findall(x,open(Board,x),MIN), 
   length(MIN,Emin),      % # lines open to x
   E is Emax - Emin.

other_player(o,x).
other_player(x,o).


alpha_beta(_Player,0,Position,_Alpha,_Beta,_NoMove,Value) :- 
   value(Position,Value).

alpha_beta(Player,D,Position,Alpha,Beta,Move,Value) :- 
   D > 0, 
   findall((X,Y),mark(Player,Position,X,Y),Moves), 
   Alpha1 is -Beta, % max/min
   Beta1 is -Alpha,
   D1 is D-1, 
   evaluate_and_choose(Player,Moves,Position,D1,Alpha1,Beta1,nil,(Move,Value)).

evaluate_and_choose(Player,[Move|Moves],Position,D,Alpha,Beta,Record,BestMove) :-
   move(Player,Move,Position,Position1), 
   other_player(Player,OtherPlayer),
   alpha_beta(OtherPlayer,D,Position1,Alpha,Beta,_OtherMove,Value),
   Value1 is -Value,
   cutoff(Player,Move,Value1,D,Alpha,Beta,Moves,Position,Record,BestMove).
evaluate_and_choose(_Player,[],_Position,_D,Alpha,_Beta,Move,(Move,Alpha)).

cutoff(_Player,Move,Value,_D,_Alpha,Beta,_Moves,_Position,_Record,(Move,Value)) :- 
   Value >= Beta, !.
cutoff(Player,Move,Value,D,Alpha,Beta,Moves,Position,_Record,BestMove) :- 
   Alpha < Value, Value < Beta, !, 
   evaluate_and_choose(Player,Moves,Position,D,Value,Beta,Move,BestMove).
cutoff(Player,_Move,Value,D,Alpha,Beta,Moves,Position,Record,BestMove) :- 
   Value =< Alpha, !, 
   evaluate_and_choose(Player,Moves,Position,D,Alpha,Beta,Record,BestMove).

