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


toBoardSize(1, 7).
toBoardSize(2, 9).
toBoardSize(3, 11).
toBoardSize(4, 13).

toDifficulty(1, 'Easy').
toDifficulty(2, 'Hard').

getPlayerName(1, 'Player 1').
getPlayerName(-1, 'Player 2').



readDigitBounds(LowerBound, UpperBound, Number):-
    format('Choose an Action (~d-~d): ', [LowerBound, UpperBound]),
    get_code(InputCode),
    peek_char(Char),
    Char == '\n',
    get_char(Char),
    inputToDigit(InputCode, Number),
    Number =< UpperBound, Number >= LowerBound,
    newLine.

/* printNumber:-
    readDigitBounds(2,5,Number),
    format('| Read (~d) - ', [Number]). */

chooseMove:-
    
    readDigitBounds(1,2,Number),
    executeMove(Number).

executeMove(1):- write('| You chose nr 1').

executeMove(2):- write('| You chose nr 2').


% consult('src/main.pl').