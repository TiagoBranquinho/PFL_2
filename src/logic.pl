print_valid_moves([]):- newLine.

print_valid_moves([H|T]):- 
    printmove(H), print_valid_moves(T).

printmove(pair(pair(X,Y), P)):- 
    format('Valid move: x ~d y ~d p ~d\n', [X,Y,P]).

valid_moves(1, _, [], _, []).

valid_moves(1, Row, [CurrLine|NextLine], Player, [App|ListOfMoves]):- 
    valid_moves_aux(Row, 0, CurrLine, Player, App),
    NewRow = Row + 1,
    valid_moves(1, NewRow, NextLine, Player, ListOfMoves).

valid_moves_aux(_, _, [], _ , []).

valid_moves_aux(Row, Column, [0|T], Player, [pair(pair(Row, Column), Player), pair(pair(Row, Column), 5) | ListOfMoves]):- 
    NewColumn = Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).


valid_moves_aux(Row, Column, [H|T], Player, ListOfMoves):- 
    H \= 0,
    NewColumn = Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).

foo(H, [H|_]).
foo(H, [_, T]):- foo(H,T).


validate_move(1, Gamestate, Move):- 
    %Move2 = [pair(pair(0,0), 1), pair(pair(0,1),5)],
    getCurrBoard(Gamestate, Board),
    getCurrPlayer(Gamestate, Player),
    valid_moves(1, 0, Board, Player, ListOfMovesAux),
    flatten_list(ListOfMovesAux, ListOfMoves),
    write('gatooo\n'),
    nth0(0, Move, Move_1),
    printmove(Move_1),
    print_valid_moves(ListOfMoves),
    foo(Move_1, ListOfMoves),
    write('deu').
validate_move(1, Gamestate, Move):- 
    write('sheesh').


flatten_list([], []).
flatten_list([Head|Tail], FlatList) :-
    flatten_list(Head, HeadFlat),
    flatten_list(Tail, TailFlat),
    append(HeadFlat, TailFlat, FlatList).
flatten_list(Element, [Element]) :-
    \+ is_list(Element).


cao:- 
    validate_move(1, 
        [
            1,  [
                [0,1], 
                [1,0]
                ] 
        ], 
        [pair(pair(1,1), 1), pair(pair(0,1),5)]).