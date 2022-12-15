tile_empty(Tile):- 
    Tile == 0.

%empty_tiles(BoardListOfEmpty):- 
    %exclude(tile_empty, Board, ListOfEmpty).

empty_tiles(_, [], _, ListOfEmpty):- write('donemainloop\n').

empty_tiles(Row, [CurrLine|NextLine], Player, ListOfEmpty):- 
    empty_tiles_row(Row, 0, CurrLine, Player, ListOfEmpty),
    duck(ListOfEmpty),
    NewRow = Row + 1,
    empty_tiles(NewRow, NextLine, Player, ListOfEmpty).
    

empty_tiles_row(_, _, [], _ , ListOfEmpty):- duck(ListOfEmpty).

empty_tiles_row(Row, Column, [0|T], Player, ListOfEmpty):- 
    write('viu0\n'),
    NewListOfEmpty = [pair(pair(Row, Column), Player), pair(pair(Row, Column), 5)],
    append(ListOfEmpty, NewListOfEmpty, ListOfEmptyNew),
    
    NewColumn = Column + 1,
    empty_tiles_row(Row, NewColumn, T, Player, ListOfEmptyNew).

empty_tiles_row(Row, Column, [H|T], Player, ListOfEmpty):- 
    H \= 0,
    NewColumn = Column + 1,
    write('nao0\n'),
    empty_tiles_row(Row, NewColumn, T, Player, ListOfEmpty).


getxy(pair(pair(X,Y), P), X, Y, P).
%valid_moves(Gamestate, Player, ListOfMoves).
duck([]):- newLine.
duck([H|T]):- 
    getxy(H, X, Y, P),
    format('x -> ~d  y -> ~d (player ~d) \n', [X,Y, P]),
    duck(T).

gato:- 
    empty_tiles(0, [[1,1,0], [0,2,3], [0,1,0]], 1, AA).