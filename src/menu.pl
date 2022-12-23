menuHeaderText(Text) :- format('~n~`*t ~p ~`*t~57|~n', [Text]).


pvpMenu(BoardSizeOpt) :-
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    read_digit_bounds(1, 2, Choice),
    pvpMenuNext(Choice, BoardSizeOpt).

pveMenu(BoardSizeOpt, DifficultyOpt) :-
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'ADJUST DIFFICULTY'),
    optionNewLine(3, 'GO BACK'),
    %toDifficulty(BoardSizeOpt, BoardSize),
    %format('Current = ~d: ', [BoardSize]),
    read_digit_bounds(1, 3, Choice),
    pveMenuNext(Choice, BoardSizeOpt, DifficultyOpt).

rulesMenu(BoardSizeOpt, DifficultyOpt) :-
    write('THE RULES ARE PRETTY SIMPLE\n\n'),
    readInput,
    menu(BoardSizeOpt, DifficultyOpt).

mainMenuNext(1, BoardSizeOpt, Difficulty) :- pvpMenu(BoardSizeOpt).

mainMenuNext(2, BoardSizeOpt, Difficulty) :- pveMenu(BoardSizeOpt, Difficulty).

mainMenuNext(3, BoardSizeOpt, Difficulty) :- rulesMenu(BoardSizeOpt, DifficultyOpt).

mainMenuNext(4, BoardSizeOpt, Difficulty) :- boardSizeMenu.

mainMenuNext(5, BoardSizeOpt, Difficulty) :- halt(0).

pvpMenuNext(1, BoardSizeOpt) :- %PLAY PVP   
    initial_state(BoardSizeOpt, Gamestate),
    update_game(Gamestate).

pvpMenuNext(2, BoardSizeOpt) :-
    menu(BoardSizeOpt, 1).

pveMenuNext(1, BoardSizeOpt, DifficultyOpt) :- %PLAY PVE   
initial_state(BoardSizeOpt, Gamestate),
update_game(Gamestate).

pveMenuNext(2, BoardSizeOpt, DifficultyOpt) :-
    write('Choose your difficulty\n\n'),
    optionNewLine(1, 'Easy'),
    optionNewLine(2, 'Hard'),
    read_digit_bounds(1, 2, Choice),
    toDifficulty(Choice, NewDifficulty),
    write('The new difficulty is'),
    write($NewDifficulty),
    write('\n\n'),
    pveMenu(BoardSizeOpt, NewDifficulty).

pveMenuNext(3, BoardSizeOpt, DifficultyOpt) :-
    menu(BoardSizeOpt, 1).

rulesMenuNext(1, BoardSizeOpt, Difficulty) :- menu(BoardSizeOpt, Difficulty).

newLine :- write('\n').

optionNewLine(Number, Text) :-
    option(Number, Text),
    newLine.

option(Number, Text) :-
    format('~d - ~s', [Number, Text]).

boardSizeMenu :- 
    optionNewLine(1, '7x7'),
    optionNewLine(2, '9x9'),
    optionNewLine(3, '11x11'),
    optionNewLine(4, '13x13'),
    read_digit_bounds(1, 4, BoardSizeOpt),
    toBoardSize(BoardSizeOpt, BoardSize),
    format('Board Size successfully changed to: ~d \n', [BoardSize]),
    menu(BoardSizeOpt, Difficulty).


menu(BoardSizeOpt, Difficulty):-
    menuHeaderText('WELCOME TO THE NEX GAME'),
    optionNewLine(1, 'PVP'),
    optionNewLine(2, 'PVE'),
    optionNewLine(3, 'RULES'),
    option(4, 'ADJUST BOARD SIZE'),
    toBoardSize(BoardSizeOpt, BoardSize),
    format(' (Current = ~d)', [BoardSize]),
    newLine,
    optionNewLine(5, 'QUIT'),
    read_digit_bounds(1, 5, Choice),
    mainMenuNext(Choice, BoardSizeOpt, Difficulty).





retrieve_move_menu(Gamestate, Move) :-
    write('Choose your move'),
    newLine, newLine,
    optionNewLine(1, 'Place a stone AND a neutral one on empty cells'),
    optionNewLine(2, 'Replace two neutral stones with your stones AND replace a different stone of yours on the board to neutral stone'),
    read_digit_bounds(1, 2, Choice),
    retrieve_move_menu_next(Choice, Gamestate, Move).

retrieve_move_menu_next(1, Gamestate, Move) :- first_move_menu(Gamestate, Move).

retrieve_move_menu_next(2, Move, Gamestate) :- second_move_menu(Gamestate, Move).

first_move_menu_next(1, Gamestate, Move):- 
    validate_move(1, Gamestate, Move).

first_move_menu_next(2, Gamestate, Move):- 
    update_game(Gamestate).

first_move_menu(Gamestate, Move):- 
    write('Insert coordinates to place a stone of yours'), newLine,
    write('Column '),
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    length(Board, MaxColumnRowDigit),
    NewMax is MaxColumnRowDigit + 1,
    read_column_bounds(1, NewMax, ColumnNumber),
    digit_to_column(ColumnNumber, ColumnChar),
    write('Line: '),
    read_row_bounds(1, NewMax, RowNumber),
    format('Chosen coordinates: ~s~d', [ColumnChar, RowNumber]), newLine,
    write('Insert coordinates to place neutral stone'), newLine,
    write('Column '),
    read_column_bounds(1, NewMax, ColumnNumber_2),
    digit_to_column(ColumnNumber_2, ColumnChar_2),
    write('Line: '),
    read_row_bounds(1, NewMax, RowNumber_2),
    format('Chosen coordinates: ~s~d', [ColumnChar_2, RowNumber_2]), newLine,
    optionNewLine(1, 'Continue'),
    optionNewLine(2, 'Redo move chosen'),
    read_digit_bounds(1, 3, Choice),
    Move = [pair(pair(RowNumberAdjust, ColumnNumberAdjust), Player), pair(pair(RowNumber_2Adjust, ColumnNumber_2Adjust), 5)],
    RowNumberAdjust is RowNumber - 1, RowNumber_2Adjust is RowNumber_2 - 1, ColumnNumberAdjust is ColumnNumber - 1, ColumnNumber_2Adjust is ColumnNumber_2 - 1,
    first_move_menu_next(Choice, Gamestate, Move).

    


