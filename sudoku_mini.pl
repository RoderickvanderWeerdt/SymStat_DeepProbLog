%sudoku code retrieved from: https://thecodeboss.dev/2018/08/declarative-programming-with-prolog-part-3-putting-it-all-together/
%training code retrieved from: https://bitbucket.org/problog/deepproblog/src/022a74294ed02d6fdaaa2414b57e52325d14266e/examples/NIPS/MNIST/single_digit/addition.pl
%with added in/2, ins/2, all_distinct/1 & all_distinct/2 functions.

in(H, [H|_]).
in(V, [_|T]) :-
        in(V, T).

ins([], _).
ins([H|T], Dom) :-
        in(H, Dom),
        ins(T, Dom).


all_distinct(_, []).
all_distinct(H, [HH|T]) :-
        H \= HH,
        all_distinct(H, T).

all_distinct([]).
all_distinct([H|T]) :-
        all_distinct(H, T),
        all_distinct(T).

%% digits([Himage|Timages], [Hvalue, Tvalues]) :-
%%     digit(Himage, Hvalue),
%%     digits(Timages, Tvalues).
%% digits([], []).

sudoku(Puzzle, Solution) :-
        Solution = PuzzleNumbers,
        Puzzle = [S11i, S12i, S13i, S14i,
                  S21i, S22i, S23i, S24i,
                  S31i, S32i, S33i, S34i,
                  S41i, S42i, S43i, S44i],

        PuzzleNumbers = [S11, S12, S13, S14,
                  S21, S22, S23, S24,
                  S31, S32, S33, S34,
                  S41, S42, S43, S44],

        %% digits(Puzzle, PuzzleNumbers),

        digit(S11i, S11),
        digit(S12i, S12),
        digit(S13i, S13),
        digit(S14i, S14),
        digit(S21i, S21),
        digit(S22i, S22),
        digit(S23i, S23),
        digit(S24i, S24),
        digit(S31i, S31),
        digit(S32i, S32),
        digit(S33i, S33),
        digit(S34i, S34),
        digit(S41i, S41),
        digit(S42i, S42),
        digit(S43i, S43),
        digit(S44i, S44),
 
        ins(PuzzleNumbers, [1, 2, 3, 4]),
 
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
 
        valid([Row1, Row2, Row3, Row4,
               Col1, Col2, Col3, Col4,
               Square1, Square2, Square3, Square4]).
 
valid([]).
valid([Head|Tail]) :-
    all_distinct(Head),
    valid(Tail).

% code for training the test set
nn(mnist_net,[X],Y,[0,1,2,3,4,5,6,7,8,9]) :: digit(X,Y).

addition(X,Y,Z) :- digit(X,X2), digit(Y,Y2), Z is X2+Y2.