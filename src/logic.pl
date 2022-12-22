valid_moves(1, _, [], _, []).

valid_moves(1, Row, [CurrLine|NextLine], Player, [App|ListOfMoves]):- 
    valid_moves_aux(Row, 0, CurrLine, Player, App),
    NewRow is Row + 1,
    valid_moves(1, NewRow, NextLine, Player, ListOfMoves).

valid_moves_aux(_, _, [], _ , []).

valid_moves_aux(Row, Column, [0|T], Player, [pair(pair(Row, Column), Player), pair(pair(Row, Column), 5) | ListOfMoves]):- 
    NewColumn is Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).


valid_moves_aux(Row, Column, [H|T], Player, ListOfMoves):- 
    H \= 0,
    NewColumn is Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).




validate_move(1, Gamestate, Move):- 
    write('entrou meu filho\n'),
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    valid_moves(1, 0, Board, Player, ListOfMovesAux),
    flatten_list(ListOfMovesAux, ListOfMoves),
    nth0(0, Move, Move_1),
    write('first move\n'),
    printmove(Move_1),
    write('list of moves 1\n'),
    print_valid_moves(ListOfMoves),
    member(Move_1, ListOfMoves),
    write('First move approved'),
    get_move_info(Move_1, Move_1_X, Move_1_Y, Move_1_P),
    construct_move(Move_1_X, Move_1_Y, Player, Move_1_1),
    construct_move(Move_1_X, Move_1_Y, 5, Move_1_2),
    deleted(Move_1_1, ListOfMoves, NewListOfMoves),
    deleted(Move_1_2, NewListOfMoves, FinalListOfMoves),
    write('list of moves 2\n'),
    print_valid_moves(FinalListOfMoves),
    nth0(1, Move, Move_2),
    write('second move\n'),
    printmove(Move_2),
    member(Move_2, FinalListOfMoves),
    write('Second move approved').

validate_move(1, Gamestate, Move):- 
    newLine, newLine, write('Your move wasnt approved!'), newLine, newLine,
    update_game(Gamestate).


flatten_list([], []).
flatten_list([Head|Tail], FlatList) :-
    flatten_list(Head, HeadFlat),
    flatten_list(Tail, TailFlat),
    append(HeadFlat, TailFlat, FlatList).
flatten_list(Element, [Element]) :-
    \+ is_list(Element).


/* cao:- 
    validate_move(1, 
        [
            1,  [
                [0,1], 
                [1,0]
                ] 
        ], 
        [pair(pair(0,0), 1), pair(pair(1,1),5)]). */



