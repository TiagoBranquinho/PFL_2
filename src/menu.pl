menuHeaderText(Text) :- format('~n~`*t ~p ~`*t~57|~n', [Text]).


pvpMenu(BoardSizeOpt) :-
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    read_digit_bounds(1, 2, Choice),
    pvpMenuNext(Choice, BoardSizeOpt).

pveMenu(BoardSizeOpt) :-
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    %toDifficulty(BoardSizeOpt, BoardSize),
    %format('Current = ~d: ', [BoardSize]),
    read_digit_bounds(1, 2, Choice),
    pveMenuNext(Choice, BoardSizeOpt).

rulesMenu(BoardSizeOpt, DifficultyOpt) :-
    write('THE RULES ARE PRETTY SIMPLE\n\n'),
    readInput,
    menu(BoardSizeOpt, DifficultyOpt).

mainMenuNext(1, BoardSizeOpt) :- pvpMenu(BoardSizeOpt).

mainMenuNext(2, BoardSizeOpt) :- pveMenu(BoardSizeOpt).

mainMenuNext(3, BoardSizeOpt) :- botvbotMenu(BoardSizeOpt).

mainMenuNext(4, BoardSizeOpt) :- rulesMenu(BoardSizeOpt).

mainMenuNext(5, BoardSizeOpt) :- boardSizeMenu.

mainMenuNext(6, BoardSizeOpt) :- halt(0).


botvbotMenu(BoardSizeOpt):- 
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    %toDifficulty(BoardSizeOpt, BoardSize),
    %format('Current = ~d: ', [BoardSize]),
    read_digit_bounds(1, 2, Choice),
    botvbotMenuNext(Choice, BoardSizeOpt).


botvbotMenuNext(1, BoardSizeOpt) :- %PLAY BOT VS BOT   
write('Choose the difficulty\n\n'),
optionNewLine(1, 'Easy'),
optionNewLine(2, 'Hard'),
read_digit_bounds(1, 2, Difficulty),
initial_state(BoardSizeOpt, 3, Difficulty, Gamestate),
update_game(Gamestate).

botvbotMenuNext(2, BoardSizeOpt) :-
    menu(BoardSizeOpt).

pvpMenuNext(1, BoardSizeOpt) :- %PLAY PVP   
    initial_state(BoardSizeOpt, 1, 0, Gamestate),
    update_game(Gamestate).

pvpMenuNext(2, BoardSizeOpt) :-
    menu(BoardSizeOpt).

pveMenuNext(1, BoardSizeOpt) :- %PLAY PVE   
    write('Choose your difficulty\n\n'),
    optionNewLine(1, 'Easy'),
    optionNewLine(2, 'Hard'),
    read_digit_bounds(1, 2, Difficulty),
    initial_state(BoardSizeOpt, 2, Difficulty, Gamestate),
    update_game(Gamestate).

pveMenuNext(2, BoardSizeOpt) :-
    menu(BoardSizeOpt).

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


menu(BoardSizeOpt):-
    menuHeaderText('WELCOME TO THE NEX GAME'),
    optionNewLine(1, 'PVP'),
    optionNewLine(2, 'PVE'),
    optionNewLine(3, 'BOT vs BOT'),
    optionNewLine(4, 'RULES'),
    option(5, 'ADJUST BOARD SIZE'),
    toBoardSize(BoardSizeOpt, BoardSize),
    format(' (Current = ~d)', [BoardSize]),
    newLine,
    optionNewLine(6, 'QUIT'),
    read_digit_bounds(1, 6, Choice),
    mainMenuNext(Choice, BoardSizeOpt).


retrieve_move_menu(Gamestate, Move) :-
    getCurrWalls(Gamestate, Walls),
    Walls == [1,2],
    getCurrPlayer(Gamestate, Player),
    format('current player is ~d \n',[Player]),
    Player == -1,
    value(Gamestate, Value),
    getCurrBoard(Gamestate, Board),
    length(Board, Length),
    nth0(0, Value, EmptyCount),
    EmptyCountNeeded is Length*Length - 2,
    format('empty count ~d empty count needed ~d\n',[EmptyCount, EmptyCountNeeded]),
    EmptyCount == EmptyCountNeeded,
    write('Do you want to switch the outer walls? This is your only chance: '),
    newLine, newLine,
    optionNewLine(1, 'Yes'),
    optionNewLine(2, 'No'),
    read_digit_bounds(1, 2, Choice),
    getCurrDifficulty(Gamestate, Difficulty),
    (Choice == 1 -> invertWalls(Walls, NewWalls); NewWalls = Walls),
    create_game_state(Player, Difficulty, NewWalls, Board, NewGamestate),
    update_game(NewGamestate).

retrieve_move_menu(Gamestate, Move) :-
    write('Choose your move'),
    newLine, newLine,
    optionNewLine(1, 'Place a stone AND a neutral one on empty cells'),
    optionNewLine(2, 'Replace two neutral stones with your stones AND replace a different stone of yours on the board to neutral stone'),
    read_digit_bounds(1, 2, Choice),
    retrieve_move_menu_next(Choice, Gamestate, Move).

retrieve_move_menu_next(1, Gamestate, Move) :- first_move_menu(Gamestate, Move).

retrieve_move_menu_next(2, Gamestate, Move) :- second_move_menu(Gamestate, Move).

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
    read_digit_bounds(1, 2, Choice),
    Move = [pair(pair(RowNumberAdjust, ColumnNumberAdjust), Player), pair(pair(RowNumber_2Adjust, ColumnNumber_2Adjust), 5)],
    RowNumberAdjust is RowNumber - 1, RowNumber_2Adjust is RowNumber_2 - 1, ColumnNumberAdjust is ColumnNumber - 1, ColumnNumber_2Adjust is ColumnNumber_2 - 1,
    first_move_menu_next(Choice, Gamestate, Move).


second_move_menu_next(1, Gamestate, Move):- 
    validate_move(2, Gamestate, Move).

second_move_menu_next(2, Gamestate, Move):- 
    update_game(Gamestate).

second_move_menu(Gamestate, Move):- 
    write('Insert coordinates of neutral stone to replace with a stone of yours'), newLine,
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
    write('Insert coordinates of another neutral stone to replace with a stone of yours'), newLine,
    write('Column '),
    read_column_bounds(1, NewMax, ColumnNumber_2),
    digit_to_column(ColumnNumber_2, ColumnChar_2),
    write('Line: '),
    read_row_bounds(1, NewMax, RowNumber_2),
    format('Chosen coordinates: ~s~d', [ColumnChar_2, RowNumber_2]), newLine,
    write('Insert coordinates of a stone of yours to replace with a neutral stone'), newLine,
    write('Column '),
    read_column_bounds(1, NewMax, ColumnNumber_3),
    digit_to_column(ColumnNumber_3, ColumnChar_3),
    write('Line: '),
    read_row_bounds(1, NewMax, RowNumber_3),
    format('Chosen coordinates: ~s~d', [ColumnChar_3, RowNumber_3]), newLine,
    optionNewLine(1, 'Continue'),
    optionNewLine(2, 'Redo move chosen'),
    read_digit_bounds(1, 2, Choice),
    Move = [pair(pair(RowNumberAdjust, ColumnNumberAdjust), Player), pair(pair(RowNumber_2Adjust, ColumnNumber_2Adjust), Player), pair(pair(RowNumber_3Adjust, ColumnNumber_3Adjust), 5)],
    RowNumberAdjust is RowNumber - 1, RowNumber_2Adjust is RowNumber_2 - 1, RowNumber_3Adjust is RowNumber_3 - 1, ColumnNumberAdjust is ColumnNumber - 1, ColumnNumber_2Adjust is ColumnNumber_2 - 1, ColumnNumber_3Adjust is ColumnNumber_3 - 1,
    second_move_menu_next(Choice, Gamestate, Move).

    


