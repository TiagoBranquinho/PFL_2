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


toBoardSize(1, 5).
toBoardSize(2, 6).
toBoardSize(3, 7).
toBoardSize(4, 8).
toBoardSize(5, 9).


digit_to_column(1,'A').
digit_to_column(2,'B').
digit_to_column(3,'C').
digit_to_column(4,'D').
digit_to_column(5,'E').
digit_to_column(6,'F').
digit_to_column(7,'G').
digit_to_column(8,'H').
digit_to_column(9,'I').



digit_to_column_code(Digit, ColumnCode):- 
    digit_to_column(Digit, Column),
    char_code(Column, ColumnCode).

column_code_to_column_number(Code, Number):- 
    NewCode is Code-16,
    inputToDigit(NewCode, Number).

column_number_to_column_code(Number, Code):- 
    digitToOutput(Number, CodeAux),
    Code = CodeAux+16.




toDifficulty(1, 'Easy').
toDifficulty(2, 'Hard').

getPlayerName(1, 'Player 1').
getPlayerName(-1, 'Player 2').
getPlayerName(2, 'Player 1').
getPlayerName(-2, 'Bot').

getPlayerType(1, 'Player').
getPlayerType(-1, 'Player').
getPlayerType(2, 'Bot').

maxColumn(5, 'A').
maxColumn(6, 'B').
maxColumn(7, 'C').
maxColumn(8, 'D').
maxColumn(9, 'E').

get_tile(Row, Column, Board, Tile):- 
    nth(Row, Board, SelectedRow),
    nth(Column, SelectedRow, Tile).

get_coordinates(Move, Row, Column).

getCurrPlayer([Player,Board], Player).

getCurrBoard([Player,Board], Board).


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
read_digit_bounds(LowerBound, UpperBound, Number):-
    write('Not a valid number, try again\n'),
    read_digit_bounds(LowerBound, UpperBound, Number).

read_row_bounds(MinRow, MaxRow, RowNumber):-
    format('(~d-~d): ', [MinRow, MaxRow]),
    get_code(RowCode),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    inputToDigit(RowCode, RowNumber),
    (RowNumber =< MaxRow, RowNumber >= MinRow),
    newLine.
read_row_bounds(MinRow, MaxRow, RowNumber):-
    write('Not a valid row number, try again\n'),
    read_row_bounds(MinRow, MaxRow, RowNumber).


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
read_column_bounds(MinColumnCode, MaxColumnCode, ColumnNumber):-
    write('Not a valid column digit (needs to be uppercase), try again\n'),
    read_column_bounds(MinColumnCode, MaxColumnCode, ColumnNumber).


readInput :- 
    write('Press any key to return to Main Menu... '),
    get_code(Byte),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    newLine.


/* 
consult('src/main.pl'). 
*/
% play.

