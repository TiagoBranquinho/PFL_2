% inputToDigit(+Input, -Decimal)
% Get decimal number of ascii input
inputToDigit(48, 0).
inputToDigit(49, 1).
inputToDigit(50, 2).
inputToDigit(51, 3).
inputToDigit(52, 4).
inputToDigit(53, 5).
inputToDigit(54, 6).
inputToDigit(55, 7).
inputToDigit(56, 8).
inputToDigit(57, 9).

% digitToOutput(+Digit, -Outout)
% Get ascii code of decinal number
digitToOutput(0,48).
digitToOutput(1,49).
digitToOutput(2,50).
digitToOutput(3,51).
digitToOutput(4,52).
digitToOutput(5,53).
digitToOutput(6,54).
digitToOutput(7,55).
digitToOutput(8,56).
digitToOutput(9,57).

% toBoardSize(+Option, -BoardSize)
% Get BoardSize of Option chosen
toBoardSize(1, 5).
toBoardSize(2, 6).
toBoardSize(3, 7).
toBoardSize(4, 8).
toBoardSize(5, 9).

% digit_to_column(+Digit, -ColumnChar)
% Get the ColumnChar of respective Column Number
digit_to_column(1,'A').
digit_to_column(2,'B').
digit_to_column(3,'C').
digit_to_column(4,'D').
digit_to_column(5,'E').
digit_to_column(6,'F').
digit_to_column(7,'G').
digit_to_column(8,'H').
digit_to_column(9,'I').


% digit_to_column_code(+Digit, -ColumnCode)
% Get the ascii code of the Column Char associated with a Column Number
digit_to_column_code(Digit, ColumnCode):- 
    digit_to_column(Digit, Column),
    char_code(Column, ColumnCode).


% column_code_to_column_number(+Code, -Number)
% Get the Column Number from the ascii code of the Column Char
column_code_to_column_number(Code, Number):- 
    NewCode is Code-16,
    inputToDigit(NewCode, Number).

% column_number_to_column_code(+Code, -Number)
% Get the ascii code of the Column Char from the Column Number
column_number_to_column_code(Number, Code):- 
    digitToOutput(Number, CodeAux),
    Code = CodeAux+16.

% toDifficulty(+Option, -Difficulty)
% Get the Difficulty from the Option chosen
toDifficulty(1, 'Easy').
toDifficulty(2, 'Hard').

% toDifficulty(+Option, -Difficulty)
% Get the Difficulty from the Option chosen
getPlayerName(1, 'Player 1').
getPlayerName(-1, 'Player 2').
getPlayerName(2, 'Player 1').
getPlayerName(-2, 'Bot').
getPlayerName(3, 'Bot 1').
getPlayerName(-3, 'Bot 2').

% getPlayerChar(+Player, -PlayerChar)
% Get the player's symbol in board
getPlayerChar(1, 1).
getPlayerChar(-1, 2).
getPlayerChar(2, 1).
getPlayerChar(-2, 2).
getPlayerChar(3, 1).
getPlayerChar(-3, 2).

% getPlayerType(+Player, -Type)
% Get the player's type
getPlayerType(1, 'Player').
getPlayerType(-1, 'Player').
getPlayerType(2, 'Player').
getPlayerType(-2, 'Bot').
getPlayerType(3, 'Bot').
getPlayerType(-3, 'Bot').

% getCurrPlayer(+Gamestate, -Player)
% Get the current Player from the Gamestate
getCurrPlayer([Player, Difficulty, Walls, Board], Player).

% getCurrPlayerChar(+Gamestate, -PlayerChar)
% Get the current Player's symbol from the Gamestate
getCurrPlayerChar(Gamestate, PlayerChar):- 
    getCurrPlayer(Gamestate, Player),
    getPlayerChar(Player, PlayerChar).

% getCurrBoard(+Gamestate, -Board)
% Get the current Board from the Gamestate
getCurrBoard([Player, Difficulty, Walls, Board], Board).

% getCurrDifficulty(+Gamestate, -Difficulty)
% Get the current Difficulty from the Gamestate
getCurrDifficulty([Player, Difficulty, Walls, Board], Difficulty).

% getCurrWalls(+Gamestate, -Walls)
% Get the current outer Walls from the Gamestate
getCurrWalls([Player, Difficulty, Walls, Board], Walls).

% invertWalls(+OLdWalls, -NewWalls)
% Inverts outer walls of the board
invertWalls([VerticalWalls, HorizontalWalls, InvertChoiceMade], [HorizontalWalls, VerticalWalls, InvertChoiceMade]).

% getWallsInfo(+Walls, -VerticalWalls, -HorizontalWalls)
% Gets Vertical and horizontal walls symbols
getWallsInfo([VerticalWalls, HorizontalWalls, InvertChoiceMade], VerticalWalls, HorizontalWalls).

% deleted(+Element, +InitialList, -FinalList)
% Deletes an element from a list, if it exists
deleted(X, [H|L1], [H|L2]) :- X\=H, !, deleted(X,L1,L2).
deleted(X, [X|L1],    L2)  :-       !, deleted(X,L1,L2).
deleted(_, [], []).



print_valid_moves([]):- newLine.

print_valid_moves([H|T]):- 
    printmove(H), print_valid_moves(T).

printmove(pair(pair(X,Y), P)):- 
    format('Valid move: x ~d y ~d p ~d\n', [X,Y,P]).

get_move_info(+Move, -Row, -Col, Player):-
% Get the Row, Column and new Symbol of that Tile from a move
    get_move_info(pair(pair(X,Y), P), X, Y, P).

% construct_move(+Gamestate, -Walls)
% Get the current outer Walls from the Gamestate
construct_move(X, Y, P, pair(pair(X,Y), P)).


% read_digit_bounds(+LowestOption, +HighestOption, -OptionChosen)
% Read an input from the user within LowestOption and HighestOption
read_digit_bounds(LowerBound, UpperBound, Number):-
    format('Choose an Action (~d-~d): ', [LowerBound, UpperBound]),
    get_code(InputCode),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    inputToDigit(InputCode, Number),
    newLine,
    (Number =< UpperBound, Number >= LowerBound),
    newLine.

% If option chosen isn't in bounds, recall try to read again
read_digit_bounds(LowerBound, UpperBound, Number):-
    write('Not a valid number, try again\n'),
    read_digit_bounds(LowerBound, UpperBound, Number).

% read_row_bounds(+LowestRow, +HighestRow, -RowChosen)
% Read an input from the user within LowestRow and HighestRow
read_row_bounds(MinRow, MaxRow, RowNumber):-
    format('(~d-~d): ', [MinRow, MaxRow]),
    get_code(RowCode),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    inputToDigit(RowCode, RowNumber),
    (RowNumber =< MaxRow, RowNumber >= MinRow),
    newLine.

% If row chosen isn't in bounds, try to read again
read_row_bounds(MinRow, MaxRow, RowNumber):-
    write('Not a valid row number, try again\n'),
    read_row_bounds(MinRow, MaxRow, RowNumber).

% read_column_bounds(+LowestCol, +HighestCol, -ColChosen)
% Read an input from the user within LowestCol and HighestCol
read_column_bounds(MinColumn, MaxColumn, ColumnNumber):-
    column_number_to_column_code(MinColumn, MinColumnCode),
    column_number_to_column_code(MaxColumn, MaxColumnCode),
    format('(~c-~c): ', [MinColumnCode, MaxColumnCode]),
    get_code(ColumnCode),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    column_code_to_column_number(ColumnCode, ColumnNumber),
    (ColumnNumber =< MaxColumn, ColumnNumber >= MinColumn),
    newLine.

% If col chosen isn't in bounds, try to read again
read_column_bounds(MinColumnCode, MaxColumnCode, ColumnNumber):-
    write('Not a valid column digit (needs to be uppercase), try again\n'),
    read_column_bounds(MinColumnCode, MaxColumnCode, ColumnNumber).

% readInput
% Wait for an input from the user
readInput :- 
    write('Press any key and hit enter to return to Main Menu... '),
    get_code(Byte),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    newLine.


% update_matrix(+OldMatrix, +Row, +Col, +Symbol, -NewMatrix)
% Update the matrix OldMatrix, changing the value of the tile in row Row and column Col to Symbol 
update_matrix(CurrMatrix, Row, Column, Value, UpdatedMatrix) :-
    nth0(Row, CurrMatrix, CurrentRow, TempMatrix),
    nth0(Column, CurrentRow, _, RowTemp),
    nth0(Column, UpdatedRow, Value, RowTemp),
    nth0(Row, UpdatedMatrix, UpdatedRow, TempMatrix).

% value(+Gamestate, -Value)
% Get the amount of empty, neutral, player 1's and player 2's tiles from the Gamestate
value(Gamestate, Value):- 
    getCurrBoard(Gamestate, Board),
    count_element_in_matrix(Board, 0, EmptyCount),
    count_element_in_matrix(Board, 5, NeutralCount),
    count_element_in_matrix(Board, 1, Player1Count),
    count_element_in_matrix(Board, 2, Player2Count),
    Value = [EmptyCount, NeutralCount, Player1Count, Player2Count].

    
% count_element_in_matrix(+Matrix, +Element, -Count)
% Count the ammount of times Element appears in a matrix Matrix
count_element_in_matrix([], _, 0).
count_element_in_matrix([CurrRow|NextRow], Element, Count) :-
    count_element_in_row(CurrRow, Element, RowCount),
    count_element_in_matrix(NextRow, Element, RemainingCount),
    Count is RowCount + RemainingCount.

% count_element_in_row(+Row, +Element, -Count)
% Count the ammount of times Element appears in a row Row
count_element_in_row([], _, 0).
count_element_in_row([Elem|Elems], Element, Count) :-
    (   Elem = Element
    ->  NewCount is 1
    ;   NewCount is 0
    ),
    count_element_in_row(Elems, Element, RemainingCount),
    Count is NewCount + RemainingCount.


pair_with_2(pair(pair(_,_),2)).

pair_with_5(pair(pair(_,_),5)).

pair_with_1(pair(pair(_,_),1)).

% get_element_matrix(+Matrix, +Row, +Col, -Element)
% Get Element in row Row and column Col of Matrix
get_element_matrix(Matrix, Row, Col, Element) :-
    nth0(Row, Matrix, RowList),
    nth0(Col, RowList, Element).


% flatten_list(+OldList, -NewList)
% Flattens a list
flatten_list([], []).
flatten_list([Head|Tail], FlatList) :-
    flatten_list(Head, HeadFlat),
    flatten_list(Tail, TailFlat),
    append(HeadFlat, TailFlat, FlatList).
flatten_list(Element, [Element]) :-
    \+ is_list(Element).
