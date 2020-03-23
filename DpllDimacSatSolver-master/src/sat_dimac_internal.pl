:- module(sat_dimac_internal,
    [ sat_internal/2
    , dpll/2
    , dpll/3,
    , vars_dimac/2
    , to_positive/2
    , assign_free_vars/2
    , simpl/3
    , simpl_line/3
    , example/2
    , cnf_normal/3
    , sort_cnf/2
    , sort_cnf/2
    ]).

:- use_module(library(lists)).
:- use_module('./parser_dimac_internal').
:- use_module(library(readutil)).


vars_dimac(DIMAC,Unique) :-
    flatten(DIMAC,I1),
    to_positive(I1,I2),
    list_to_set(I2,Unique).


to_positive([Z|Zs],[N|Ns]) :-
    ((0 > Z) ->
        N is 0 - Z
    ;   N = Z),
    to_positive(Zs,Ns).
to_positive([],[]).


assign_free_vars([Head0|Tail0],[(Head0,_)|Tail1]) :-
    assign_free_vars(Tail0,Tail1).
assign_free_vars([],[]).


simpl((Var,'T'),[Line0|Lines0], Lines1) :-
    member(Var,Line0),
    simpl((Var,'T'),Lines0,Lines1).
simpl((Var,'F'),[Line0|Lines0], Lines1) :-
    NegVar is 0 - Var,
    member(NegVar,Line0),
    simpl((Var,'F'),Lines0,Lines1).
simpl((Var,Value),[Line0|Lines0], [Line1|Lines1]) :-
    NegVar is 0 - Var,
    \+ (member(Var,Line0), Value = 'T'),
    \+ (member(NegVar,Line0), Value = 'F'),
    simpl_line((Var,Value),Line0,Line1),
    simpl((Var,Value),Lines0,Lines1).
simpl((_,_),[],[]).


simpl_line((Var,'F'),Line0,Line1) :-
    member(Var,Line0),
    subtract(Line0,[Var],Line1).
simpl_line((Var,'T'),Line0,Line1) :-
    NegVar is 0 - Var,
    member(NegVar,Line0),
    subtract(Line0,[NegVar],Line1).
simpl_line((Var,_),Line0,Line0) :-
    NegVar is 0 - Var,
    \+ member(Var,Line0),
    \+ member(NegVar,Line0).

empty_clause(dimac0) :-
    element([],dimac0).

assign_unit_clauses(VarValues,Dimac0,Dimac1) :-
    get_unit_clauses(Dimac0,Units),
    (dif(Units,[]) ->
        !,
        remove_units(Units,VarValues,Dimac0,IDimac1),
        assign_unit_clauses(VarValues,IDimac1,Dimac1)
    ; !, Dimac0 = Dimac1
    ).
assign_unit_clauses(_,Dimac0,Dimac0) :-
    get_unit_clauses(Dimac0,[]).


get_unit_clauses([[Unit]|Lines],[Unit|Units]) :-
    get_unit_clauses(Lines,Units).
get_unit_clauses([Line|Lines],Units) :-
    dif(Line,[_]),
    get_unit_clauses(Lines,Units).
get_unit_clauses([],[]).


remove_units([Var|Vars],VarValues,Dimac0,Dimac1) :-
    (Var < 0 ->
            PosVar is 0 - (Var),
            VarValue = (PosVar,'F')
    ; VarValue = (Var,'T')
    ),
    member(VarValue,VarValues),
    simpl(VarValue,Dimac0,IDimac1),
    remove_units(Vars,VarValues,IDimac1,Dimac1).
remove_units([],_,Dimac0,Dimac0).


dpll(Dimac, Model) :-
    vars_dimac(Dimac,Vars),
    assign_free_vars(Vars,VarsValues),
    dpll(VarsValues,Dimac,[]),
	Model = VarsValues.

dpll(VarValues,Dimac0,Dimac1) :-
    \+ empty_clause(Dimac0),
    VarValues = [(Var,Value)|VarValues1],
    assign_unit_clauses(VarValues,Dimac0,IDimac1),
    boolean(Value),
    simpl((Var,Value),IDimac1,IDimac2),
    dpll(VarValues1,IDimac2,Dimac1).
dpll([],Dimac,Dimac).


example(Y):-cnf_normal([1,_,_,8,_,4,_,_,_,
_,2,_,_,_,_,4,5,6,
_,_,3,2,_,5,_,_,_,
_,_,_,4,_,_,8,_,5,
7,8,9,_,5,_,_,_,_,
_,_,_,_,_,6,2,_,3,
8,_,1,_,_,_,7,_,_,
_,_,_,1,2,3,_,8,_,
2,_,5,_,_,_,_,_,9],[11,12,13,14,15,16,17,18,19,
                 21,22,23,24,25,26,27,28,29,
                 31,32,33,34,35,36,37,38,39,
                 41,42,43,44,45,46,47,48,49,
                 51,52,53,54,55,56,57,58,59,
                 61,62,63,64,65,66,67,68,69,
                 71,72,73,74,75,76,77,78,79,
                 81,82,83,84,85,86,87,88,89,
                 91,92,93,94,95,96,97,98,99],X),
                 sort_cnf(X,Y).


/*
CNF_normal Function1
*/

cnf_normal([H],[H2],[[H2,H]]):- nonvar(H).
cnf_normal([H],[H2],[[H2]]):- var(H).

cnf_normal([H|T],[H2|T2],[[H2,H]|T3]):- nonvar(H),
  cnf_normal(T,T2,T3).

  cnf_normal([H|T],[H2|T2],[[H2]|T3]):- var(H),
    cnf_normal(T,T2,T3).

/*
Sorting CNF Function

*/

sort_cnf2([H2,H],Result):-
  number_string(H2,H2String),
  number_string(H,HString),
  string_concat(H2String, HString, HSolved),
  atom_number(HSolved, HSolved2),
  Result is HSolved2.

sort_cnf2([_],[]).


sort_cnf([H],[R]):-
  sort_cnf2(H,R).

sort_cnf([H|T],[R|T2]):-
  sort_cnf2(H,R),
  sort_cnf(T,T2).

/*

*/


sat_internal(DimacCodes,Model) :-
    parse_dimac(DimacCodes,Dimac),
    dpll(Dimac2,Model).


boolean('T').
boolean('F').
