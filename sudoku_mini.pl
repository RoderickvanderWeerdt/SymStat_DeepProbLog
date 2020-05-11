%sudoku code retrieved from: https://thecodeboss.dev/2018/08/declarative-programming-with-prolog-part-3-putting-it-all-together/
%training code retrieved from: https://bitbucket.org/problog/deepproblog/src/022a74294ed02d6fdaaa2414b57e52325d14266e/examples/NIPS/MNIST/single_digit/addition.pl
%with added in/2, ins/2, all_distinct/1 & all_distinct/2 functions.


/*----------------------------------------------------*/
/* Neural predicates and digit recognition - Prolog side */

% code for training the test set
nn(mnist_net,[X],Y,[0,1,2,3,4,5,6,7,8,9]) :: digit(X,Y).

/* Single Digit addition */
%addition(X,Y,Z) :- digit(X,X2), digit(Y,Y2), Z is X2+Y2.

/* Multi Digit addition */
number([],Result,Result).
number([H|T],Acc,Result) :- digit(H,Nr), Acc2 is Nr+10*Acc,number(T,Acc2,Result).
number(X,Y) :- number(X,0,Y).

addition(X,Y,Z) :- number(X,X2), number(Y,Y2), Z is X2+Y2.


/*------ins and in----------------------------------------------*/
/* To check whether or not something is in the list */

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

/* -----Memberchk from  https://eclipseclp.org/doc/bips/lib/lists/memberchk-2.html-------s------------------ */
memberchk(X,[X|_]) :- true.
memberchk(X,[_|T]):- memberchk(X,T).

unique([]).
unique([X|Xs]) :- \+ memberchk(X, Xs), unique(Xs).

/*----------------------------------------------*/



/* --- Digits Function to go over a list of Digits --- */

digits([Himage],[Hvalue]):-
    digit(Himage,Hvalue).

digits([Himage|Timages], [Hvalue|Tvalues]) :-
    digit(Himage, Hvalue),
    digits(Timages, Tvalues).


/*--------------Sudoku Main code-----------------*/
sudoku4(Puzzle, Love):-
  digits(Puzzle, Solution),
  sudoku2_4(Solution, Love).

Sudoku9(Puzzle, Love):-
  digits(Puzzle, Solution),
  sudoku2_9(Solution, Love).


/* ----- Sudoku Helper Function --=-------------------------*/

sudoku2_4(Solution, Found):-

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
        love_func_4(Love,Found).

sudoku2_9(Solution, Found):-
        ins(Solution, [1,2,3,4,5,6,7,8,9],Hype),

        Hype = [S11, S12, S13, S14, S15, S16, S17, S18, S19,
                S21, S22, S23, S24, S25, S26, S27, S28, S29,
                S31, S32, S33, S34, S35, S36, S37, S38, S39,
                S41, S42, S43, S44, S45, S46, S47, S48, S49,
                S51, S52, S53, S54, S55, S56, S57, S58, S59,
                S61, S62, S63, S64, S65, S66, S67, S68, S69,
                S71, S72, S73, S74, S75, S76, S77, S78, S79,
                S81, S82, S83, S84, S85, S86, S87, S88, S89,
                S91, S92, S93, S94, S95, S96, S97, S98, S99],

        

        Row1 =  [S11, S12, S13, S14, S15, S16, S17, S18, S19],
        Row2 =  [S21, S22, S23, S24, S25, S26, S27, S28, S29],
        Row3 =  [S31, S32, S33, S34, S35, S36, S37, S38, S39],
        Row4 =  [S41, S42, S43, S44, S45, S46, S47, S48, S49],
        Row5 =  [S51, S52, S53, S54, S55, S56, S57, S58, S59],
        Row6 =  [S61, S62, S63, S64, S65, S66, S67, S68, S69],
        Row7 =  [S71, S72, S73, S74, S75, S76, S77, S78, S79],
        Row8 =  [S81, S82, S83, S84, S85, S86, S87, S88, S89],
        Row9 =  [S91, S92, S93, S94, S95, S96, S97, S98, S99], 
        
        Col1 = [S11, S21, S31, S41, S51, S61, S71, S81, S91],
        Col2 = [S12, S22, S32, S42, S52, S62, S72, S82, S92],
        Col3 = [S13, S23, S33, S43, S53, S63, S73, S83, S93],
        Col4 = [S14, S24, S34, S44, S54, S64, S74, S84, S94],
        Col5 = [S15, S25, S35, S45, S55, S65, S75, S95, S95],
        Col6 = [S16, S26, S36, S46, S56, S66, S76, S86, S96],
        Col7 = [S17, S27, S37, S47, S57, S67, S77, S87, S97],
        Col8 = [S18, S28, S38, S48, S58, S68, S78, S88, S98],
        Col9 = [S19, S29, S39, S49, S59, S69, S79, S89, S99],
        
        Square1 = [S11, S12, S13, S21, S22, S23, S31, S32, S33],
        Square2 = [S14, S15, S16, S24, S25, S26, S34, S35, S36],
        Square3 = [S17, S18, S19, S27, S28, S29, S37, S38, S39],
        Square4 = [S41, S42, S43, S51, S52, S53, S61, S62, S63],
        Square5 = [S44, S45, S46, S54, S55, S56, S64, S65, S66],
        Square6 = [S47, S48, S49, S57, S58, S59, S67, S68, S69],
        Square7 = [S71, S72, S73, S81, S82, S83, S91, S92, S93],
        Square8 = [S74, S75, S76, S84, S85, S86, S94, S95, S96],
        Square9 = [S77, S78, S79, S87, S88, S89, S97, S98, S99],

        valid2([Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8, Row9,
               Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9,
               Square1, Square2, Square3, Square4, Square5, Square6, Square7, Square8, Square9], Love),
        love_func_9(Love,Found).

/* ----------Fixer Function (for droppig cols and squares)--------------------------------------- */
love_func_4([HA,HB,HC,HD|T], Found_in_between):-
   HA = [A1,A2,A3,A4],
   HB = [B1,B2,B3,B4],
   HC = [C1,C2,C3,C4],
   HD = [D1,D2,D3,D4],
   Found_in_between = [A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4].
/*------------Fixer Function (for dropping cols and squares)------------------------------------------*/

love_func_9([HA,HB,HC,HD,HE,HF,HG,HH,HI|T], Found_in_between):-
   HA = [A1,A2,A3,A4,A5,A6,A7,A8,A9],
   HB = [B1,B2,B3,B4,B5,B6,B7,B8,B9],
   HC = [C1,C2,C3,C4,C5,C6,C7,C8,C9],
   HD = [D1,D2,D3,D4,D5,D6,D7,D8,D9],
   HE = [E1,E2,E3,E4,E5,E6,E7,E8,E9],
   HF = [F1,F2,F3,F4,F5,F6,F7,F8,F9],
   HG = [G1,G2,G3,G4,G5,G6,G7,G8,G9],
   HH = [H1,H2,H3,H4,H5,H6,H7,H8,H9],
   HI = [I1,I2,I3,I4,I5,I6,I7,I8,I9],
   Found_in_between = [A1,A2,A3,A4,A5,A6,A7,A8,A9,B1,B2,B3,B4,B5,B6,B7,B8,B9,C1,C2,C3,C4,C5,C6,C7,C8,C9,D1,D2,D3,D4,D5,D6,D7,D8,D9,E1,E2,E3,E4,E5,E6,E7,E8,E9,F1,F2,F3,F4,F5,F6,F7,F8,F9,G1,G2,G3,G4,G5,G6,G7,G8,G9,H1,H2,H3,H4,H5,H6,H7,H8,H9,I1,I2,I3,I4,I5,I6,I7,I8,I9].




/* Valid function and it's helper functions */
valid(Head, H) :-
    unique(Head),
    H = Head.

valid2([Head],H):-
  valid(Head,H).

valid2([Head|Tail], [H|T]):-
    valid(Head, H),
    valid2(Tail,T).
/* ---------------------------------------- */
