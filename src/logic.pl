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

%valid_moves(Gamestate, Player, ListOfMoves).


