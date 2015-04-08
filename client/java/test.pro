/* -*- Mode:Prolog; coding:iso-8859-1; -*- */

% Exemple 1 : cette ligne est un commentaire
habite(frederic,vesoul).
habite(fabrice,marseille).
habite(fabien,belfort).
habite(jacques,vesoul).
meme(X,Y) :- habite(X,V),habite(Y,V).

% Exemple 2 : appartient(X,L) 
appartient(X,[X|Y]).
appartient(X,[Z|Y]):- appartient(X,Y).

% Approche avec accumulateur (solution 1)
concatene1([],L,L).
concatene1([X|L1],L2,R):-
concatene1(L1,[X|L2],R).
% Approche sans accumulateur (solution 2a)
concatene2a([],L,L).
concatene2a([X|L1],L2,R):-
concatene2a(L1,L2,R1),
R=[X|R1].
% Approche sans accumulateur (solution 2b)
concatene2b([],L,L).
concatene2b([X|L1],L2,[X|R1]):-
concatene2b(L1,L2,R1).

% Exemple 4 : utilisation de \+
complement(X,L,M):-
appartient(X,L),
\+ appartient(X,M).

% Exemple 5 : utilisation de read/1 et write/1
double:- write('Entrez un nombre :'),
         read(A),
         Z is 2*A,
         nl,
        write('Le double de '),
        write(A),
        write(' est '),
        write(Z).

% Exemple 6 : appartient 1(X,L)
appartient_1(X,[X|_]):-!.
appartient_1(X,[_|Y]):-
appartient_1(X,Y).




