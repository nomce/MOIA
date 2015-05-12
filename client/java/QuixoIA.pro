/* -*- Mode:Prolog; coding:iso-8859-1; -*- */
:-set_prolog_flag(toplevel_print_options, [max_depth(0)]).
:-use_module(library(lists)).
:-use_module(library(clpfd)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                        %%%%%%%%%%
%%%%%%%%%%   Quixo - Predicates   %%%%%%%%%%
%%%%%%%%%%                        %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% General Rules of Quixo %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the opponent in order to not move its pieces.
opponent(x, o).
opponent(o, x).

% True if the 6 arguments are equal.
equal(X, X, X, X, X, X).

% Check the winning pattern.
winPos(P, [X01, X02, X03, X04, X05,
            X06, X07, X08, X09, X10,
            X11, X12, X13, X14, X15,
            X16, X17, X18, X19, X20,
            X21, X22, X23, X24, X25]):-
    equal(X01, X02, X03, X04, X05, P) ;    % 1st line
    equal(X06, X07, X08, X09, X10, P) ;    % 2nd line
    equal(X11, X12, X13, X14, X15, P) ;    % 3rd line
    equal(X16, X17, X18, X19, X20, P) ;    % 4th line
    equal(X21, X22, X23, X24, X25, P) ;    % 5th line
    
    equal(X01, X06, X11, X16, X21, P) ;    % 1st column
    equal(X02, X07, X12, X17, X22, P) ;    % 2nd column
    equal(X03, X08, X13, X18, X23, P) ;    % 3rd column
    equal(X04, X09, X14, X19, X24, P) ;    % 4th column
    equal(X05, X10, X15, X20, X25, P) ;    % 5th column
    
    equal(X01, X07, X13, X19, X25, P) ;    % 1st diagonal
    equal(X05, X09, X13, X17, X21, P).     % 2nd diagonal

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Exchange predicates %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exchange the element at Pos1 and Pos2 on the board and copy the rest.
exchangePos(Board, Pos1, Pos2, NewBoard):-
        nth1(Pos1, Board, NewElement2),
        nth1(Pos2, Board, NewElement1),
        exchangePosAux(Board, Pos1, Pos2, NewElement1, NewElement2, [], TmpBoard),
        reverse(TmpBoard, NewBoard).

% End of the board
exchangePosAux([], _Pos1, _Pos2, _NewElement1, _NewElement2, Acc, Acc).

% At the Pos1 element we put NewElement1 in Acc.
exchangePosAux([_X | L], Pos1, Pos2, NewElement1, NewElement2, Acc, NewBoard):-
        Pos1 =:= 1,
        NewPos1 is Pos1 - 1,
        NewPos2 is Pos2 - 1,
        exchangePosAux(L, NewPos1, NewPos2, NewElement1, NewElement2, [NewElement1 | Acc], NewBoard).

% At the Pos2 element we put NewElement2 in Acc.
exchangePosAux([_X | L], Pos1, Pos2, NewElement1, NewElement2, Acc, NewBoard):-
        Pos2 =:= 1,
        NewPos1 is Pos1 - 1,
        NewPos2 is Pos2 - 1,
        exchangePosAux(L, NewPos1, NewPos2, NewElement1, NewElement2, [NewElement2 | Acc], NewBoard).

% For each position different of Pos1 and Pos2, we copy the board element in Acc.
exchangePosAux([X | L], Pos1, Pos2, NewElement1, NewElement2, Acc, NewBoard):-
        \+ Pos1 =:= 1,
        \+ Pos2 =:= 1,
        NewPos1 is Pos1 - 1,
        NewPos2 is Pos2 - 1,
        exchangePosAux(L, NewPos1, NewPos2, NewElement1, NewElement2, [X | Acc], NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define Top Movements %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the list of the position that can move Top.
topMovable([6, 10, 11, 15, 16, 20, 21, 22, 23, 24, 25]).

% If we are at the top line, we identify the new board with the current board.
moveTop(Board, Pos, Board):-
        Pos < 6.

% If we are not at the top line, we exchange our current position with the one on top of it and continue.
moveTop(Board, Pos, NewBoard):-
        Pos > 5,
        NewPos is Pos - 5,
        exchangePos(Board, Pos, NewPos, TmpBoard),
        moveTop(TmpBoard, NewPos, NewBoard).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define Bottom Movements %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the list of the position that can move Bottom.
bottomMovable([1, 2, 3, 4, 5, 6, 10, 11, 15, 16, 20]).

% If we are at the bottom line, we identify the new board with the current board.
moveBottom(Board, Pos, Board):-
        Pos > 20.

% If we are not at the bottom line, we exchange our current position with the one under it and continue.
moveBottom(Board, Pos, NewBoard):-
        Pos < 21,
        NewPos is Pos + 5,
        exchangePos(Board, Pos, NewPos, TmpBoard),
        moveBottom(TmpBoard, NewPos, NewBoard).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define Left Movements %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the list of the position that can move Left.
leftMovable([2, 3, 4, 5, 10, 15, 20, 22, 23, 24, 25]).

% If we are at the left line, we identify the new board with the current board.
moveLeft(Board, Pos, Board):-
        R is (Pos - 1) mod 5,
        R == 0.

% If we are not at the left line, we exchange our current position with the one left to it and continue.
moveLeft(Board, Pos, NewBoard):-
        R is (Pos - 1) mod 5,
        \+ R == 0,
        NewPos is Pos - 1,
        exchangePos(Board, Pos, NewPos, TmpBoard),
        moveLeft(TmpBoard, NewPos, NewBoard).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define Right Movements %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the list of the position that can move Right.
rightMovable([1, 2, 3, 4, 6, 11, 16, 21, 22, 23, 24]).

% If we are at the right line, we identify the new board with the current board.
moveRight(Board, Pos, Board):-
        R is Pos mod 5,
        R == 0.

% If we are not at the right line, we exchange our current position with the one right to it and continue.
moveRight(Board, Pos, NewBoard):-
        R is Pos mod 5,
        \+ R == 0,
        NewPos is Pos + 1,
        exchangePos(Board, Pos, NewPos, TmpBoard),
        moveRight(TmpBoard, NewPos, NewBoard).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define General Movements %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

copyWithPlayer([], _Player, _Pos, Acc, NewBoard):-
        reverse(Acc, NewBoard).

copyWithPlayer([_X | L], Player, Pos, Acc, NewBoard):-
        Pos == 1,
        NewPos is Pos - 1,
        copyWithPlayer(L, Player, NewPos, [Player | Acc], NewBoard).

copyWithPlayer([X | L], Player, Pos, Acc, NewBoard):-
        \+ Pos == 1,
        NewPos is Pos - 1,
        copyWithPlayer(L, Player, NewPos, [X | Acc], NewBoard).

% move(+Board, +Player, -NewBoard, -Pos, -Direction)
% For the Board and the player, we create a NewBoard with a movement from Pos towards Direction.

% moving top, we check the top-movable pieces for the player and move it.
moveAux(Board, Player, NewBoard, Pos, t):-
        topMovable(M),
        member(Pos, M),
        opponent(Player, Opp),
        \+ nth1(Pos, Board, Opp),
        copyWithPlayer(Board, Player, Pos, [], TmpBoard),
        moveTop(TmpBoard, Pos, NewBoard).

% moving bottom, we check the bottom-movable pieces for the player and move it.
moveAux(Board, Player, NewBoard, Pos, b):-
        bottomMovable(M),
        member(Pos, M),
        opponent(Player, Opp),
        \+ nth1(Pos, Board, Opp),
        copyWithPlayer(Board, Player, Pos, [], TmpBoard),
        moveBottom(TmpBoard, Pos, NewBoard).

% moving left, we check the left-movable pieces for the player and move it.
moveAux(Board, Player, NewBoard, Pos, l):-
        leftMovable(M),
        member(Pos, M),
        opponent(Player, Opp),
        \+ nth1(Pos, Board, Opp),
        copyWithPlayer(Board, Player, Pos, [], TmpBoard),
        moveLeft(TmpBoard, Pos, NewBoard).

% moving right, we check the right-movable pieces for the player and move it.
moveAux(Board, Player, NewBoard, Pos, r):-
        rightMovable(M),
        member(Pos, M),
        opponent(Player, Opp),
        \+ nth1(Pos, Board, Opp),
        copyWithPlayer(Board, Player, Pos, [], TmpBoard),
        moveRight(TmpBoard, Pos, NewBoard).

move(Board, Player, NewBoard, Pos, Dir):-
        \+ winPos(Player, Board),
        opponent(Player, Opponent),
        \+ winPos(Opponent, Board),
        moveAux(Board, Player, NewBoard, Pos, Dir).

move(Board, Player, Board, _Pos, w):-
        winPos(Player, Board).

move(Board, Player, Board, _Pos, w):-
        opponent(Player, Opponent),
        winPos(Opponent, Board).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                             %%%%%%%%%%
%%%%%%%%%%   Evaluation - Predicates   %%%%%%%%%%
%%%%%%%%%%                             %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the alignments dangerousness of the player %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

playerAlignmentsValues([-10, 0, 10, 50, 100, 1000]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First Diagonal Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% playerFirstDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result).
% Return in Result the value of the alignment.

% Identify the value of the alignment.
playerFirstDiagonalAlignments(_Board, _Player, _Pos, 0, Acc, Result):-
        playerAlignmentsValues(AlignmentsValues),
        nth0(Acc, AlignmentsValues, Result).

% If this is a player's position, increment Acc.
playerFirstDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        nth1(Pos, Board, Player),
        NextPos is Pos + 6,
        NewAcc is Acc + 1,
        NewCounter is Counter - 1,
        playerFirstDiagonalAlignments(Board, Player, NextPos, NewCounter, NewAcc, Result).

% Else just go on.
playerFirstDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        \+ nth1(Pos, Board, Player),
        NextPos is Pos + 6,
        NewCounter is Counter - 1,
        playerFirstDiagonalAlignments(Board, Player, NextPos, NewCounter, Acc, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second Diagonal Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% playerSecondDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result).
% Return in Result the value of the alignment.

% Identify the value of the alignment.
playerSecondDiagonalAlignments(_Board, _Player, _Pos, 0, Acc, Result):-
        playerAlignmentsValues(AlignmentsValues),
        nth0(Acc, AlignmentsValues, Result).

% If this is a player's position, increment Acc.
playerSecondDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        nth1(Pos, Board, Player),
        NextPos is Pos + 4,
        NewAcc is Acc + 1,
        NewCounter is Counter - 1,
        playerSecondDiagonalAlignments(Board, Player, NextPos, NewCounter, NewAcc, Result).

% Else just go on.
playerSecondDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        \+ nth1(Pos, Board, Player),
        NextPos is Pos + 4,
        NewCounter is Counter - 1,
        playerSecondDiagonalAlignments(Board, Player, NextPos, NewCounter, Acc, Result).
        

%%%%%%%%%%%%%%%%%%%%%%%
% Vertical Alignments %
%%%%%%%%%%%%%%%%%%%%%%%

% playerCountVerticalAlignPositions(Board, Player, Pos, Counter, Acc, Result).
% Calculate the number of position in the column of Pos.

% Every position was seen so Acc contains the result.
playerCountVerticalAlignPositions(_Board, _Player, _Pos, 0, Acc, Acc).

% If it is the a position of the player we're looking at, we count one moe and continue.
playerCountVerticalAlignPositions(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        nth1(Pos, Board, Player),
        NextPos is Pos + 5,
        NewAcc is Acc + 1,
        NewCounter is Counter - 1,
        playerCountVerticalAlignPositions(Board, Player, NextPos, NewCounter, NewAcc, Result).

% Else we just continue.
playerCountVerticalAlignPositions(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        \+ nth1(Pos, Board, Player),
        NextPos is Pos + 5,
        NewCounter is Counter - 1,
        playerCountVerticalAlignPositions(Board, Player, NextPos, NewCounter, Acc, Result).

% playerVerticalAlignments(Board, Player, Counter, Acc, Result).
% Calculate the total value of all vertical alignments in Result for the Player.

% All five columns have been seen.
playerVerticalAlignments(_Board, _Player, 0, Acc, Acc).

% Calculate the current column value and go to the next.
playerVerticalAlignments(Board, Player, Counter, Acc, Result):-
        \+ Counter == 0,
        playerCountVerticalAlignPositions(Board, Player, Counter, 5, 0, TmpNbAlign),
        playerAlignmentsValues(AlignmentsValues),
        nth0(TmpNbAlign, AlignmentsValues, TmpResult),
        NewAcc is Acc + TmpResult,
        NewCounter is Counter - 1,
        playerVerticalAlignments(Board, Player, NewCounter, NewAcc, Result).


%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizontal Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%

% playerCountHorizontalAlignPositions(Board, Player, Pos, Counter, Acc, Result).
% Calculate the number of position in the line of Pos.

% Every position was seen so Acc contains the result.
playerCountHorizontalAlignPositions(_Board, _Player, _Pos, 0, Acc, Acc).

% If it is the a position of the player we're looking at, we count one more and continue.
playerCountHorizontalAlignPositions(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        nth1(Pos, Board, Player),
        NextPos is Pos + 1,
        NewAcc is Acc + 1,
        NewCounter is Counter - 1,
      playerCountHorizontalAlignPositions(Board, Player, NextPos, NewCounter, NewAcc, Result).

% Else we just continue.
playerCountHorizontalAlignPositions(Board, Player, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        \+ nth1(Pos, Board, Player),
        NextPos is Pos + 1,
        NewCounter is Counter - 1,
        playerCountHorizontalAlignPositions(Board, Player, NextPos, NewCounter, Acc, Result).

% playerHorizontalAlignments(Board, Player, Counter, Acc, Result).
% Calculate the total value of all horizontal alignments in Result for the Player.

% All five lines have been seen.
playerHorizontalAlignments(_Board, _Player, 0, Acc, Acc).

% Calculate the current lines value and go to the next.
playerHorizontalAlignments(Board, Player, Counter, Acc, Result):-
        \+ Counter == 0,
        Pos is 1 + (5 - Counter) * 5,
        playerCountHorizontalAlignPositions(Board, Player, Pos, 5, 0, TmpNbAlign),
        playerAlignmentsValues(AlignmentsValues),
        nth0(TmpNbAlign, AlignmentsValues, TmpResult),
        NewAcc is Acc + TmpResult,
        NewCounter is Counter - 1,
        playerHorizontalAlignments(Board, Player, NewCounter, NewAcc, Result).

% Calculate the total value of the alignments potential.
playerAlignmentsDangerousness(Board, Player, Result):-
        playerHorizontalAlignments(Board, Player, 5, 0, ResultHorizontal),
        playerVerticalAlignments(Board, Player, 5, 0, ResultVertical),
        playerFirstDiagonalAlignments(Board, Player, 1, 5, 0, ResultFirstDiagonal),
        playerSecondDiagonalAlignments(Board, Player, 5, 5, 0, ResultSecondDiagonal),
        Result is ResultHorizontal + ResultVertical + ResultFirstDiagonal + ResultSecondDiagonal.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the alignments dangerousness of the opponent %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opponentAlignmentsValues([-10, 0, 10, 50, 800, 10000]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First Opponent Diagonal Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% opponentFirstDiagonalAlignments(Board, Opponent, Pos, Counter, Acc, Result).
% Return in Result the value of the alignment.

% Identify the value of the alignment.
opponentFirstDiagonalAlignments(_Board, _Opponent, _Pos, 0, Acc, Result):-
        playerAlignmentsValues(AlignmentsValues),
        nth0(Acc, AlignmentsValues, Result).

% If this is a player's position, increment Acc.
opponentFirstDiagonalAlignments(Board, Opponent, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        nth1(Pos, Board, Opponent),
        NextPos is Pos + 6,
        NewAcc is Acc + 1,
        NewCounter is Counter - 1,
        opponentFirstDiagonalAlignments(Board, Opponent, NextPos, NewCounter, NewAcc, Result).

% Else just go on.
opponentFirstDiagonalAlignments(Board, Opponent, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        \+ nth1(Pos, Board, Opponent),
        NextPos is Pos + 6,
        NewCounter is Counter - 1,
        opponentFirstDiagonalAlignments(Board, Opponent, NextPos, NewCounter, Acc, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second Opponent Diagonal Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% opponentSecondDiagonalAlignments(Board, Player, Pos, Counter, Acc, Result).
% Return in Result the value of the alignment.

% Identify the value of the alignment.
opponentSecondDiagonalAlignments(_Board, _Opponent, _Pos, 0, Acc, Result):-
        opponentAlignmentsValues(AlignmentsValues),
        nth0(Acc, AlignmentsValues, Result).

% If this is a player's position, increment Acc.
opponentSecondDiagonalAlignments(Board, Opponent, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        nth1(Pos, Board, Opponent),
        NextPos is Pos + 4,
        NewAcc is Acc + 1,
        NewCounter is Counter - 1,
        opponentSecondDiagonalAlignments(Board, Opponent, NextPos, NewCounter, NewAcc, Result).

% Else just go on.
opponentSecondDiagonalAlignments(Board, Opponent, Pos, Counter, Acc, Result):-
        \+ Counter == 0,
        \+ nth1(Pos, Board, Opponent),
        NextPos is Pos + 4,
        NewCounter is Counter - 1,
        opponentSecondDiagonalAlignments(Board, Opponent, NextPos, NewCounter, Acc, Result).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opponent Vertical Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% playerVerticalAlignments(Board, Player, Counter, Acc, Result).
% Calculate the total value of all vertical alignments in Result for the Player.

% All five columns have been seen.
opponentVerticalAlignments(_Board, _Player, 0, Acc, Acc).

% Calculate the current column value and go to the next.
opponentVerticalAlignments(Board, Opponent, Counter, Acc, Result):-
        \+ Counter == 0,
        playerCountVerticalAlignPositions(Board, Opponent, Counter, 5, 0, TmpNbAlign),
        opponentAlignmentsValues(AlignmentsValues),
        nth0(TmpNbAlign, AlignmentsValues, TmpResult),
        NewAcc is Acc + TmpResult,
        NewCounter is Counter - 1,
        opponentVerticalAlignments(Board, Opponent, NewCounter, NewAcc, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opponent Horizontal Alignments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% opponentHorizontalAlignments(Board, Opponent, Counter, Acc, Result).
% Calculate the total value of all horizontal alignments in Result for the Opponent.

% All five lines have been seen.
opponentHorizontalAlignments(_Board, _Player, 0, Acc, Acc).

% Calculate the current lines value and go to the next.
opponentHorizontalAlignments(Board, Opponent, Counter, Acc, Result):-
        \+ Counter == 0,
        Pos is 1 + (5 - Counter) * 5,
        playerCountHorizontalAlignPositions(Board, Opponent, Pos, 5, 0, TmpNbAlign),
        opponentAlignmentsValues(AlignmentsValues),
        nth0(TmpNbAlign, AlignmentsValues, TmpResult),
        NewAcc is Acc + TmpResult,
        NewCounter is Counter - 1,
        opponentHorizontalAlignments(Board, Opponent, NewCounter, NewAcc, Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opponent Alignments Potential %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the total value of the alignments potential.
opponentAlignmentsDangerousness(Board, Opponent, Result):-
        opponentHorizontalAlignments(Board, Opponent, 5, 0, ResultHorizontal),
        opponentVerticalAlignments(Board, Opponent, 5, 0, ResultVertical),
        opponentFirstDiagonalAlignments(Board, Opponent, 1, 5, 0, ResultFirstDiagonal),
        opponentSecondDiagonalAlignments(Board, Opponent, 5, 5, 0, ResultSecondDiagonal),
        Result is ResultHorizontal + ResultVertical + ResultFirstDiagonal + ResultSecondDiagonal.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the total evaluation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the value of the Board for the Player.
utility(Board, Player, Val):-
        opponent(Player, Opponent),
        playerAlignmentsDangerousness(Board, Player, ResultPlayerAlignment),
        opponentAlignmentsDangerousness(Board, Opponent, ResultOpponentAlignment),
        Val is ResultPlayerAlignment - ResultOpponentAlignment.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                          %%%%%%%%%%
%%%%%%%%%%   Minimax - Predicates   %%%%%%%%%%
%%%%%%%%%%                          %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the minimax we call with Jasper.
% Pos is the position in the list. Dir is t, b, l, r
minimax(Board, PlayerMark, Depth, Pos, Dir) :-
        minimax(Depth, Board, PlayerMark, 1, _Value, [_NewBoard, Pos, Dir]).

/* minimax(+Depth, +Position, +Player, -BestValue, -BestMove) :-
      Chooses the BestMove from the from the current Position
      using the minimax algorithm searching Depth ply ahead.
      Player indicates if this move is by player (1) or opponent (-1).
*/
minimax(0, Board, PlayerMark, Player, Value, _Best) :- 
      utility(Board, PlayerMark, V),
      Value is V*Player.   % Value is from the current player’s perspective.
minimax(D, Board, PlayerMark, Player, Value, [NewBoard, Pos, Dir]) :-
      D > 0, 
      D1 is D - 1,
      findall([NewBoard, Pos, Dir] , move(Board, PlayerMark, NewBoard, Pos, Dir), Boards), % There must be at least one move!
      length(Boards, _Length),
      minimax(Boards, PlayerMark, D1, Player, -50000, nil, Value, [NewBoard, Pos, Dir]).

/* minimax(+Moves,+Position,+Depth,+Player,+Value0,+Move0,-BestValue,-BestMove)
      Chooses the Best move from the list of Moves from the current Position
      using the minimax algorithm searching Depth ply ahead.
      Player indicates if we are currently minimizing (-1) or maximizing (1).
      Move0 records the best move found so far and Value0 its value.
*/
minimax([], _PlayerMark, _D, _Player, Value, Best, Value, Best).

minimax([[Board, Pos, Dir] | Boards], PlayerMark, D, Player, Value0, Board0, BestValue, BestMove):-
      Opponent is -Player,
      opponent(PlayerMark, OpponentMark),
      minimax(D, Board, OpponentMark, Opponent, OppValue, _Board), 
      Value is -OppValue,
      length(Boards, _Length),
      ( Value > Value0 ->        
        minimax(Boards, PlayerMark, D, Player, Value, [Board, Pos, Dir], BestValue, BestMove)
      ; minimax(Boards, PlayerMark, D, Player, Value0, Board0, BestValue, BestMove)
      ).
