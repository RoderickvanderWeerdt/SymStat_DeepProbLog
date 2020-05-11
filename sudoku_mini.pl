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


/*------ins and in----------------------------------------------*/

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

/* ----------- XXX https://eclipseclp.org/doc/bips/lib/lists/memberchk-2.html------------------------- */
memberchk(X,[X|_]) :- true.
memberchk(X,[_|T]):- memberchk(X,T).

unique([]).
unique([X|Xs]) :- \+ memberchk(X, Xs), unique(Xs).

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

digits([Himage],[Hvalue]):-
    digit(Himage,Hvalue).

digits([Himage|Timages], [Hvalue|Tvalues]) :-
    digit(Himage, Hvalue),
    digits(Timages, Tvalues).
/* ------------------------------------------------- */
love_func([HA,HB,HC,HD|T], Found_in_between):-
   HA = [A1,A2,A3,A4],
   HB = [B1,B2,B3,B4],
   HC = [C1,C2,C3,C4],
   HD = [D1,D2,D3,D4],
   Found_in_between = [A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4].

/* ----- Sudoku Function --=-------------------------*/

sudoku2(Solution, Found):-

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
               Square1, Square2, Square3, Square4], Love),
        love_func(Love,Found).


/*--------------Sudoku Without Open Spots-----------------*/
sudoku(Puzzle, Love):-
  digits(Puzzle, Solution),
  sudoku2(Solution, Love).
/*------------------------------------------------------*/


/* Valid function and it's helper functions */
valid(Head, H) :-
    unique(Head),
    %all_distinct(Head),
    H = Head.

valid2([Head],H):-
  valid(Head,H).

valid2([Head|Tail], [H|T]):-
    valid(Head, H),
    valid2(Tail,T).
/* ---------------------------------------- */
