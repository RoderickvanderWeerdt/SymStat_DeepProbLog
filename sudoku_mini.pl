%sudoku code retrieved from: https://thecodeboss.dev/2018/08/declarative-programming-with-prolog-part-3-putting-it-all-together/
%training code retrieved from: https://bitbucket.org/problog/deepproblog/src/022a74294ed02d6fdaaa2414b57e52325d14266e/examples/NIPS/MNIST/single_digit/addition.pl
%with added in/2, ins/2, all_distinct/1 & all_distinct/2 functions.


/*----------------------------------------------------*/

% code for training the test set
nn(mnist_net,[X],Y,[0,1,2,3,4,5,6,7,8,9]) :: digit(X,Y).

%addition(X,Y,Z) :- digit(X,X2), digit(Y,Y2), Z is X2+Y2.

number([],Result,Result).
number([H|T],Acc,Result) :- digit(H,Nr), Acc2 is Nr+10*Acc,number(T,Acc2,Result).
number(X,Y) :- number(X,0,Y).

addition(X,Y,Z) :- number(X,X2), number(Y,Y2), Z is X2+Y2.


/*----------------------------------------------------*/

in(H, [H|_]).
in(V, [_|T]) :-
        in(V, T).

ins([H],Dom,[H2]):-
  in(H, Dom),
  H2 = H.

ins([H|T], Dom, [H2|T2]) :-
        in(H, Dom),
        H2 = H,
        ins(T, Dom, T2).


memberchk(X,[X|_]) :- true.
memberchk(X,[_|T]):- memberchk(X,T).

unique([]).
unique([X|Xs]) :- \+ memberchk(X, Xs), unique(Xs);

not_unique([]).
not_unique([X|Xs]) :- memberchk(X, Xs), not_unique(Xs);

/*----------------------------------------------*/
all_distinct(_, []).

all_distinct(H, [HH|T]) :-
        H \= HH,
        all_distinct(H, T).

all_distinct([]).
all_distinct([H|T]) :-
        all_distinct(H, T),
        all_distinct(T).
/*--------------------------------------------*/


/* --- Digits Function to go over a list of Digits --- */

digits([], []).
digits([Himage|Timages], [Hvalue|Tvalues]) :-
    digit(Himage, Hvalue),
    digits(Timages, Tvalues).


/* ------------------------------------------------- */


/* ----- Sudoku Function --=-------------------------*/

sudoku2(Solution):-

        ins(Solution, [1, 2, 3, 4], Hype),

        Hype = [S11, S12, S13, S14,
                  S21, S22, S23, S24,
                  S31, S32, S33, S34,
                  S41, S42, S43, S44],

        Row1 = [S11, S12, S13, S14],
        Row2 = [S21, S22, S23, S24],
        Row3 = [S31, S32, S33, S34],
        Row4 = [S41, S42, S43, S44],

        Col1 = [S11, S21, S31, S41],
        Col2 = [S12, S22, S32, S42],
        Col3 = [S13, S23, S33, S43],
        Col4 = [S14, S24, S34, S44],

        Square1 = [S11, S12, S21, S22],
        Square2 = [S13, S14, S23, S24],
        Square3 = [S31, S32, S41, S42],
        Square4 = [S33, S34, S43, S44],

        valid2([Row1, Row2, Row3, Row4,
               Col1, Col2, Col3, Col4,
               Square1, Square2, Square3, Square4], Found).
       %flatten(Found,Love).

/*------------------------------------------------------*/
sudoku(Puzzle, PuzzleSolved):-
  digits(Puzzle, Solution),
  PuzzleSolved = sudoku2(Solution).



/*

return_func(H,T):-
  H is T.

return_func([Love|Tail],[PuzzleSolved|Tail2]):-
  return_func(Tail, Tail2).
*/



/* Valid function and it's helper functions */
valid(Head, H) :-
    %unique(Head),
    all_distinct(Head),
    H = Head; H = [0,0,0,0].


valid2([Head],[H]):-
  valid(Head,H).

valid2([Head|Tail], [H|T]):-
    valid(Head, H),
    valid2(Tail,T).

/* ---------------------------------------- */
