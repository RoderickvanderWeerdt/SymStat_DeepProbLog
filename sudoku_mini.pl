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

sudoku(Puzzle, Solution) :-
        Solution = Puzzle,
        Puzzle = [S11i, S12i, S13i, S14i,
                  S21i, S22i, S23i, S24i,
                  S31i, S32i, S33i, S34i,
                  S41i, S42i, S43i, S44i],

        digit(S11i, S11, 4),
        digit(S12i, S12, 4),
        digit(S13i, S13, 4),
        digit(S14i, S14, 4),
        digit(S21i, S21, 4),
        digit(S22i, S22, 4),
        digit(S23i, S23, 4),
        digit(S24i, S24, 4),
        digit(S31i, S31, 4),
        digit(S32i, S32, 4),
        digit(S33i, S33, 4),
        digit(S34i, S34, 4),
        digit(S41i, S41, 4),
        digit(S42i, S42, 4),
        digit(S43i, S43, 4),
        digit(S44i, S44, 4),
 
        ins(Puzzle, [1, 2, 3, 4]),
 
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
nn(mnist_net,[X],Y,[0,1,2,3,4,5,6,7,8,9]) :: digit(X,Y, 10).
nn(mnist_net,[X],Y,[1,2,3,4]) :: digit(X,Y, 4).

addition(X,Y,Z) :- digit(X,X2, 4), digit(Y,Y2, 4), Z is X2+Y2.