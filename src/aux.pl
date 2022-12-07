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
toBoardSize(5,9).

digitToRow(1,'A').
digitToRow(2,'B').
digitToRow(3,'C').
digitToRow(3,'D').
digitToRow(4,'E').
digitToRow(5,'F').
digitToRow(6,'G').
digitToRow(7,'H').
digitToRow(8,'I').
digitToRow(9,'J').
digitToRow(10,'K').
digitToRow(11,'L').
digitToRow(12,'M').
digitToRow(13,'N').



toDifficulty(1, 'Easy').
toDifficulty(2, 'Hard').

getPlayerName(1, 'Player 1').
getPlayerName(-1, 'Player 2').
getPlayerName(2, 'Player 1').
getPlayerName(-2, 'Bot').

getPlayerType(1, 'Player').
getPlayerType(-1, 'Player').
getPlayerType(2, 'Bot').

getCurrPlayer([Player|Board], Player).

getCurrBoard([Player|Board], Board).


read_digit_bounds(LowerBound, UpperBound, Number):-
    format('Choose an Action (~d-~d): ', [LowerBound, UpperBound]),
    get_code(InputCode),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    inputToDigit(InputCode, Number),
    (Number =< UpperBound, Number >= LowerBound),
    newLine.
read_digit_bounds(LowerBound, UpperBound, Number):-
    write('Not a valid number, try again\n'),
    read_digit_bounds(LowerBound, UpperBound, Number).

readInput :- 
    write('Press any key to return to Main Menu... '),
    get_code(Byte),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    newLine.


% consult('src/main.pl').
% play.