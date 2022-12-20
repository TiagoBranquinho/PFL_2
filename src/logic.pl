tile_empty(Tile):- 
    Tile == 0.

%empty_tiles(BoardListOfEmpty):- 
    %exclude(tile_empty, Board, ListOfEmpty).


getxy(pair(pair(X,Y), P), X, Y, P).

duck([]):- newLine.
duck([H|T]):- 
    getxy(H, X, Y, P),
    format('x -> ~d  y -> ~d (player ~d) \n', [X,Y, P]),
    duck(T).

gato:- 
    empty_tiles(0, [[1,1,0], [0,2,3], [0,1,0]], 1, AA),
    duck(AA).

printmove(pair(pair(X,Y), P)):- 
    format('x ~d y ~d p ~d', [X,Y,P]).

valid_moves(1, _, [], _, []):- write('dass').

valid_moves(1, Row, [CurrLine|NextLine], Player, [App|ListOfMoves]):- 
    valid_moves_aux(Row, 0, CurrLine, Player, App),
    NewRow = Row + 1,
    valid_moves(1, NewRow, NextLine, Player, ListOfMoves).

valid_moves_aux(_, _, [], _ , []):- write('dasse').

valid_moves_aux(Row, Column, [0|T], Player, [pair(pair(Row, Column), Player), pair(pair(Row, Column), 5) | ListOfMoves]):- 
    NewColumn = Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).

valid_moves_aux(Row, Column, [H|T], Player, ListOfMoves):- 
    H \= 0,
    NewColumn = Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).


validate_move(Move_Type, Gamestate, Player, Move):- 
    valid_moves(Move_Type, 0, Gamestate, Player, ListOfMoves),
    nth0(0, Move, Move_1),
    printmove(Move_1).
    %member(Move_1, ListOfMoves).
