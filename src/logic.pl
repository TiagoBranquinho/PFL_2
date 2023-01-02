% valid_moves(+Type, +StartingRow, +Matrix, +Player, -ListOfMoves)
% Inserts all valid moves of type Type in ListOfMoves
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


valid_moves(2, _, [], _, []).

valid_moves(2, Row, [CurrLine|NextLine], Player, [App|ListOfMoves]):- 
    valid_moves_aux_2(Row, 0, CurrLine, Player, App),
    NewRow is Row + 1,
    valid_moves(2, NewRow, NextLine, Player, ListOfMoves).

valid_moves_aux_2(_, _, [], _ , []).

valid_moves_aux_2(Row, Column, [5|T], Player, [pair(pair(Row, Column), Player) | ListOfMoves]):- 
    NewColumn is Column + 1,
    valid_moves_aux_2(Row, NewColumn, T, Player, ListOfMoves).

valid_moves_aux_2(Row, Column, [Player|T], Player, [pair(pair(Row, Column), 5) | ListOfMoves]):- 
    NewColumn is Column + 1,
    valid_moves_aux_2(Row, NewColumn, T, Player, ListOfMoves).

valid_moves_aux_2(Row, Column, [H|T], Player, ListOfMoves):- 
    NewColumn is Column + 1,
    valid_moves_aux_2(Row, NewColumn, T, Player, ListOfMoves).



% validate_move(+Type, +Gamestate, +Move)
% Checks if a move from type Type is valid
validate_move(1, Gamestate, Move):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    valid_moves(1, 0, Board, Player, ListOfMovesAux),
    flatten_list(ListOfMovesAux, ListOfMoves),
    nth0(0, Move, Move_1),
    member(Move_1, ListOfMoves),
    get_move_info(Move_1, Move_1_X, Move_1_Y, Move_1_P),
    construct_move(Move_1_X, Move_1_Y, Player, Move_1_1),
    construct_move(Move_1_X, Move_1_Y, 5, Move_1_2),
    deleted(Move_1_1, ListOfMoves, NewListOfMoves),
    deleted(Move_1_2, NewListOfMoves, FinalListOfMoves),
    nth0(1, Move, Move_2),
    member(Move_2, FinalListOfMoves).

% If the move wasn't approved, redo the cycle to display the game and retreive the player's move
validate_move(1, Gamestate, Move):- 
    newLine, newLine, write('Your move wasnt approved!'), newLine, newLine,
    update_game(Gamestate).

validate_move(2, Gamestate, Move):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    valid_moves(2, 0, Board, Player, ListOfMovesAux),
    flatten_list(ListOfMovesAux, ListOfMoves),
    nth0(0, Move, Move_1),
    member(Move_1, ListOfMoves),
    deleted(Move_1, ListOfMoves, NewListOfMoves),
    nth0(1, Move, Move_2),
    printmove(Move_2),
    member(Move_2, NewListOfMoves),
    deleted(Move_2, NewListOfMoves, FinalListOfMoves),
    nth0(2, Move, Move_3),
    member(Move_3, FinalListOfMoves).

% If the move wasn't approved, redo the cycle to display the game and retreive the player's move
validate_move(2, Gamestate, Move):- 
    newLine, newLine, write('Your move wasnt approved!'), newLine, newLine,
    readInput, newLine,
    update_game(Gamestate).



% matrix_has_path_bottom(+Matrix, +Row, +Col, +Symbol, +Path)
% Checks if the Element in the row Row and column Col of Matrix has a path for the bottom row of the Matrix
matrix_has_path_bottom(Board, Row, Col, Symbol, Path) :-
    length(Board, Length),
    NewLength is Length - 1,
    Row =:= NewLength,
    get_element_matrix(Board, Row, Col, SymbolFound),
    SymbolFound = Symbol.

matrix_has_path_bottom(Board, Row, Col, Symbol, Path) :-
    get_element_matrix(Board, Row, Col, SymbolFound),
    SymbolFound = Symbol,
    length(Board, Length),
    Row < Length, Col < Length, Row > -1, Col > -1,
    \+ member((Row, Col), Path), % make sure the element has not been visited before
    Up is Row - 1, Down is Row + 1, Left is Col - 1, Right is Col + 1,
    (   matrix_has_path_bottom(Board, Up, Col, Symbol, [(Row, Col)|Path]) %up
    ;   matrix_has_path_bottom(Board, Down, Col, Symbol, [(Row, Col)|Path]) %down
    ;   matrix_has_path_bottom(Board, Row, Left, Symbol, [(Row, Col)|Path]) %left
    ;   matrix_has_path_bottom(Board, Row, Right, Symbol, [(Row, Col)|Path]) %right
    ;   matrix_has_path_bottom(Board, Up, Right, Symbol, [(Row, Col)|Path]) %upright
    ;   matrix_has_path_bottom(Board, Down, Left, Symbol, [(Row, Col)|Path]) %downleft
    ).

% matrix_has_path_top_bottom(+Matrix, +Symbol)
% Checks if the top row of the Matrix has a path made of tiles with the value Symbol to the bottom row of the Matrix
matrix_has_path_top_bottom(Board, Symbol) :-
    length(Board, Length),
    nth0(0, Board, TopRow), % get the top row of the matrix
    matrix_has_path_top_bottom(TopRow, 0, Board, Symbol).

matrix_has_path_top_bottom([], _, _, _):- fail. % base case: end of top row

matrix_has_path_top_bottom([Head|Tail], Col, Board, Symbol) :-
    matrix_has_path_bottom(Board, 0, Col, Symbol, []). % check for a path from the current element to the bottom border

matrix_has_path_top_bottom([_|Tail], Col, Board, Symbol) :-
    NewCol is Col + 1,
    matrix_has_path_top_bottom(Tail, NewCol, Board, Symbol). % check the next element in the top row


% matrix_has_path_right(+Matrix, +Row, +Col, +Symbol, +Path)
% Checks if the Element in the row Row and column Col of Matrix has a path for the right column of the Matrix
matrix_has_path_right(Board, Row, Col, Symbol, Path) :-
    length(Board, NumRows),
    length(Board, NumCols),
    NewNumCols is NumCols - 1,
    Col =:= NewNumCols,
    get_element_matrix(Board, Row, Col, SymbolFound),
    SymbolFound = Symbol.

matrix_has_path_right(Board, Row, Col, Symbol, Path) :-
    get_element_matrix(Board, Row, Col, SymbolFound),
    SymbolFound = Symbol,
    length(Board, Length),
    Row < Length, Col < Length, Row > -1, Col > -1,
    \+ member((Row, Col), Path), % make sure the element has not been visited before
    Up is Row - 1, Down is Row + 1, Left is Col - 1, Right is Col + 1,
    (   matrix_has_path_right(Board, Up, Col, Symbol, [(Row, Col)|Path]) %up
    ;   matrix_has_path_right(Board, Down, Col, Symbol, [(Row, Col)|Path]) %down
    ;   matrix_has_path_right(Board, Row, Left, Symbol, [(Row, Col)|Path]) %left
    ;   matrix_has_path_right(Board, Row, Right, Symbol, [(Row, Col)|Path]) %right
    ;   matrix_has_path_right(Board, Up, Right, Symbol, [(Row, Col)|Path]) %upright
    ;   matrix_has_path_right(Board, Down, Left, Symbol, [(Row, Col)|Path]) %downleft
    ).

% matrix_has_path_left_right(+Matrix, +Symbol)
% Checks if the left column of the Matrix has a path made of tiles with the value Symbol to the right column of the Matrix
matrix_has_path_left_right(Board, Symbol) :-
    maplist(nth0(0), Board, LeftColumn), % get the leftmost column of the matrix
    matrix_has_path_left_right(LeftColumn, 0, Board, Symbol).

matrix_has_path_left_right([], _, _, _):- fail. % base case: end of left column

matrix_has_path_left_right([Row|_], RowIndex, Board, Symbol) :-
    matrix_has_path_right(Board, RowIndex, 0, Symbol, []). % check for a path from the current element to the right border

matrix_has_path_left_right([_|Tail], RowIndex, Board, Symbol) :-
    NewRowIndex is RowIndex + 1,
    matrix_has_path_left_right(Tail, NewRowIndex, Board, Symbol). % check the next element in the left column


% choose_move(+Gamestate, +Difficulty, -Move)
% Choses a valid move for the computer to execute, according to the Difficulty chosen
choose_move(Gamestate, 1, Move):- 
    %write('Bot is chosing its move!\n')
    %sleep(2),
    random(1, 3, N),
    %format('First random chosen is ~d \n',[N]),
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    valid_moves(1, 0, Board, Player, ListOfMovesAux1),
    flatten_list(ListOfMovesAux1, ListOfMoves1),
    valid_moves(2, 0, Board, Player, ListOfMovesAux2),
    flatten_list(ListOfMovesAux2, ListOfMoves2),
    %write('First Move can be in :\n'),
    %print_valid_moves(ListOfMoves1),
    %write('Second Move can be in :\n'),
    %print_valid_moves(ListOfMoves2),
    ValidMoveList = [ListOfMoves1, ListOfMoves2],
    choose_move_aux(N, ValidMoveList, Move).

% choose_move_aux(+Type, +ValidMoveList, -Move)
% Choses a valid move from the ValidMoveList for the computer to execute, according to the Type of move chosen
choose_move_aux(1, ValidMoveList, Move):- 
    nth0(0, ValidMoveList, TypeChosen),
    TypeChosen \= [],
    length(TypeChosen, Length),
    %format('Length of 1 list of moves is ~d\n',[Length]),
    Length > 1,
    random(0, Length, FirstMoveIndex),
    %format('FirstMoveIndex is ~d\n',[FirstMoveIndex]),
    nth0(FirstMoveIndex, TypeChosen, FirstMove),
    %write('FirstMove is\n'),
    %printmove(FirstMove),
    get_move_info(FirstMove, Move_1_X, Move_1_Y, Move_1_P),
    construct_move(Move_1_X, Move_1_Y, Move_1_P, MoveToRemove1),
    construct_move(Move_1_X, Move_1_Y, 5, MoveToRemove2),
    %write('printing 2 moves to remove:\n'),
    %printmove(MoveToRemove1),
    %printmove(MoveToRemove2),
    deleted(MoveToRemove1, TypeChosen, NewTypeChosen),
    deleted(MoveToRemove2, NewTypeChosen, NewNewTypeChosen),
    (Move_1_P == 2 -> exclude(pair_with_2, NewNewTypeChosen, FinalTypeChosen); true),
    (Move_1_P == 1 -> exclude(pair_with_1, NewNewTypeChosen, FinalTypeChosen);true),
    (Move_1_P == 5 -> exclude(pair_with_5, NewNewTypeChosen, FinalTypeChosen);true),
    %write('2 move of first move can be in:\n'),
    %print_valid_moves(FinalTypeChosen),
    length(FinalTypeChosen, NewLength),
    random(0, NewLength, SecondMoveIndex),
    nth0(SecondMoveIndex, FinalTypeChosen, SecondMove),
    %write('Second move is \n'),
    %printmove(SecondMove),
    Move = [FirstMove, SecondMove].

% If it is impossible to execute a Move of this Type, try to execute a Move of another type
choose_move_aux(1, ValidMoveList, Move):- 
    nth0(1, ValidMoveList, TypeChosen),
    length(TypeChosen, Length),
    Length > 2,
    choose_move_aux(2, ValidMoveList, Move).

% If none of the Type are valid, ERROR
choose_move_aux(1, ValidMoveList, Move):- 
    write('ERROR\n').

choose_move_aux(2, ValidMoveList, Move):- 
    nth0(1, ValidMoveList, TypeChosen),
    TypeChosen \= [],
    length(TypeChosen, Length),
    Length > 2,
    %write('Printing ValidMoveList1\n'),
    %print_valid_moves(TypeChosen),
    random(0, Length, FirstMoveIndex),
    nth0(FirstMoveIndex, TypeChosen, FirstMove),
    %write('Printing first move\n'),
    %printmove(FirstMove),
    deleted(FirstMove, TypeChosen, NewTypeChosen),
    get_move_info(FirstMove, Move_1_X, Move_1_Y, Move_1_P),
    (Move_1_P == 5 -> exclude(pair_with_5, NewTypeChosen, NewNewTypeChosen); NewNewTypeChosen = NewTypeChosen),
    %write('Printing ValidMoveList after first move\n'),
    %print_valid_moves(NewNewTypeChosen),
    length(NewNewTypeChosen, NewLength),
    NewLength > 0,
    random(0, NewLength, SecondMoveIndex),
    nth0(SecondMoveIndex, NewNewTypeChosen, SecondMove),
    %write('Printing second move\n'),
    %printmove(SecondMove),
    deleted(SecondMove, NewNewTypeChosen, NewNewNewTypeChosen),
    get_move_info(SecondMove, Move_2_X, Move_2_Y, Move_2_P),
    (Move_2_P == 5 -> exclude(pair_with_5, NewNewNewTypeChosen, NewNewNewNewTypeChosen); true),
    (Move_2_P == 2, Move_1_P == 2 -> exclude(pair_with_2, NewNewNewTypeChosen, NewNewNewNewTypeChosen); true),
    (Move_2_P == 1, Move_1_P == 1 -> exclude(pair_with_1, NewNewNewTypeChosen, NewNewNewNewTypeChosen); true),
    %write('Printing ValidMoveList after second Move\n'),
    %print_valid_moves(NewNewNewNewTypeChosen),
    length(NewNewNewNewTypeChosen, NewNewLength),
    NewNewLength > 0,
    random(0, NewNewLength, ThirdMoveIndex),
    nth0(ThirdMoveIndex, NewNewNewNewTypeChosen, ThirdMove),
    %write('Printing Third Move\n'),
    %printmove(ThirdMove),
    Move = [FirstMove, SecondMove, ThirdMove].

% Move type 2 was chosen but not possible, redirecting to move choosing a Move of Type 1
choose_move_aux(2, ValidMoveList, Move):- 
    choose_move_aux(1, ValidMoveList, Move).
