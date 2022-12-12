tile_empty(Tile):- 
    Tile == 0.

%empty_tiles(BoardListOfEmpty):- 
    %exclude(tile_empty, Board, ListOfEmpty).

empty_tiles(_, [], _, ListOfEmpty).
empty_tiles(Row, [CurrLine|NextLine], Player, ListOfEmpty):- 
    empty_tiles_row(Row, 0, CurrLine, Player, ListOfEmpty),
    NewRow = Row + 1.
    empty_tiles(NewRow, 0, NextLine, Player, ListOfEmpty).
    

empty_tiles_row(_, _, [], _ ,ListOfEmpty).

empty_tiles_row(Row, Column, [H|T], Player, ListOfEmpty):- 
    tile_empty(H),
    append([pair(Row, Column), Player], ListOfEmpty),
    append([pair(Row, Column), 'N'], ListOfEmpty),
    NewColumn = Column +1,
    empty_tiles_row(Row, NewColumn, T, Player, ListOfEmpty).

empty_tiles_row(Row, Column, [H|T], Player, ListOfEmpty):- 
    NewColumn = Column + 1,
    empty_tiles_row(Row, NewColumn, T, Player, ListOfEmpty).


getxy([(A,B)|T], A, B).
%valid_moves(Gamestate, Player, ListOfMoves).
duck([]):- newLine.
duck([H|T]):- 
    getxy(H, X, Y),
    format('x -> ~d  y -> ~d \n', [X,Y]),
    duck(T).

gato:- 
    empty_tiles(0, [[1,1,0], [0,2,3]], 1, ListOfEmpty),
    duck(ListOfEmpty).
