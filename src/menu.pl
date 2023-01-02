% menu(+BoardSizeOpt)
% Displays main menu, where we can play, access the rules, or adjust the BoardSize
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
    menu_next(Choice, BoardSizeOpt).

% menu_next(+Choice, +BoardSizeOpt)
% Redirects to the next menu, according to the Choice
menu_next(1, BoardSizeOpt) :- pvp_menu(BoardSizeOpt).

menu_next(2, BoardSizeOpt) :- pveMenu(BoardSizeOpt).

menu_next(3, BoardSizeOpt) :- botvbotMenu(BoardSizeOpt).

menu_next(4, BoardSizeOpt) :- rulesMenu(BoardSizeOpt).

menu_next(5, BoardSizeOpt) :- boardSizeMenu.

menu_next(6, BoardSizeOpt) :- halt(0).


% pvp_menu(+BoardSizeOpt)
% Displays the player vs player menu
pvp_menu(BoardSizeOpt) :-
    clear,
    menuHeaderText('PLAYER vs PLAYER MENU'),
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    read_digit_bounds(1, 2, Choice),
    pvp_menu_next(Choice, BoardSizeOpt).


% pvp_menu_next(+Choice, +BoardSizeOpt)
% Redirects to the next menu, according to the Choice
pvp_menu_next(1, BoardSizeOpt) :- %PLAY PVP   
    initial_state(BoardSizeOpt, 1, 0, Gamestate),
    update_game(Gamestate).

pvp_menu_next(2, BoardSizeOpt) :-
    menu(BoardSizeOpt).

% pveMenu(+BoardSizeOpt)
% Displays the player vs bot menu
pveMenu(BoardSizeOpt) :-
    clear,
    menuHeaderText('PLAYER vs BOT MENU'),
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    %toDifficulty(BoardSizeOpt, BoardSize),
    %format('Current = ~d: ', [BoardSize]),
    read_digit_bounds(1, 2, Choice),
    pveMenuNext(Choice, BoardSizeOpt).

% pveMenuNext(+Choice, +BoardSizeOpt)
% Redirects to the next menu, according to the Choice. If the player wants to play, we will also need to chose the Difficulty
pveMenuNext(1, BoardSizeOpt) :- %PLAY PVE   
    write('Choose your difficulty\n\n'),
    optionNewLine(1, 'Easy'),
    optionNewLine(2, 'Hard'),
    read_digit_bounds(1, 2, Difficulty),
    initial_state(BoardSizeOpt, 2, Difficulty, Gamestate),
    update_game(Gamestate).

pveMenuNext(2, BoardSizeOpt) :-
    menu(BoardSizeOpt).

% pveMenuNext(+Choice, +BoardSizeOpt)
% Redirects to the next menu, according to the Choice. If the player wants to player, we will also need to chose the Difficulty
botvbotMenu(BoardSizeOpt):- 
    clear,
    menuHeaderText('BOT vs BOT MENU'),
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    %toDifficulty(BoardSizeOpt, BoardSize),
    %format('Current = ~d: ', [BoardSize]),
    read_digit_bounds(1, 2, Choice),
    botvbotMenuNext(Choice, BoardSizeOpt).

% botvbotMenuNext(+Choice, +BoardSizeOpt)
% Redirects to the next menu, according to the Choice. If the player wants the game to start, we will also need to chose the Difficulty
botvbotMenuNext(1, BoardSizeOpt) :- %PLAY BOT VS BOT   
write('Choose the difficulty\n\n'),
optionNewLine(1, 'Easy'),
optionNewLine(2, 'Hard'),
read_digit_bounds(1, 2, Difficulty),
initial_state(BoardSizeOpt, 3, Difficulty, Gamestate),
update_game(Gamestate).

botvbotMenuNext(2, BoardSizeOpt) :-
    menu(BoardSizeOpt).


% rulesMenu(+BoardSizeOpt)
% Present the rules. Redirects to main menu after user entering any input
rulesMenu(BoardSizeOpt) :-
    clear,
    menuHeaderText('RULES MENU'),
    write('The objective of Nex is to create a connected chain of a player\'s stones linking the opposite edges of the board marked by the player\'s number.'), newLine,
    write('You can execute 2 types of moves:'), newLine,
    optionNewLine(1, 'Place a stone AND a neutral one on empty cells'),
    optionNewLine(2, 'Replace two neutral stones with your stones AND replace a different stone of yours on the board to neutral stone'),
    write('Also Player 2, in his first move, has the possibility to switch walls with Player 1'), newLine,
    write('1 - Player 1\'s tile  2 - 2 - Player 2\'s tile  5 - Neutral tile  0 - Empty tile'), newLine,
    readInput,
    menu(BoardSizeOpt).

% boardSizeMneu(+BoardSizeOpt)
% Menu where users can change the board size
boardSizeMenu :- 
    clear,
    menuHeaderText('BOARD SIZE MENU'),
    optionNewLine(1, '5x5'),
    optionNewLine(2, '6x6'),
    optionNewLine(3, '7x7'),
    optionNewLine(4, '8x8'),
    optionNewLine(5, '9x9'),
    read_digit_bounds(1, 5, BoardSizeOpt),
    toBoardSize(BoardSizeOpt, BoardSize),
    format('Board Size successfully changed to: ~d \n', [BoardSize]),
    menu(BoardSizeOpt).


% retrieve_move_menu(+Gamestate, -Move)
% Menu where a player can chose his move type. Also if it is the first move of player 2, he can chose to invert the walls
retrieve_move_menu(Gamestate, Move) :- % if its first move of player 2, invert walls and recall main cycle
    getCurrWalls(Gamestate, Walls),
    Walls == [1,2,0],
    getCurrPlayer(Gamestate, Player),
    %format('current player is ~d \n',[Player]),
    Player == -1,
    value(Gamestate, Value),
    getCurrBoard(Gamestate, Board),
    length(Board, Length),
    nth0(0, Value, EmptyCount),
    EmptyCountNeeded is Length*Length - 2,
    %format('empty count ~d empty count needed ~d\n',[EmptyCount, EmptyCountNeeded]),
    EmptyCount == EmptyCountNeeded,
    write('Do you want to switch the outer walls? This is your only chance: '),
    newLine, newLine,
    optionNewLine(1, 'Yes'),
    optionNewLine(2, 'No'),
    read_digit_bounds(1, 2, Choice),
    getCurrDifficulty(Gamestate, Difficulty),
    (Choice == 1 -> invertWalls(Walls, NewWalls); NewWalls = Walls),
    getWallsInfo(NewWalls, VerticalWalls, HorizontalWalls),
    FinalWalls = [VerticalWalls, HorizontalWalls, 1],
    create_game_state(Player, Difficulty, FinalWalls, Board, NewGamestate),
    update_game(NewGamestate).

retrieve_move_menu(Gamestate, Move) :-
    write('Choose your move'),
    newLine, newLine,
    optionNewLine(1, 'Place a stone AND a neutral one on empty cells'),
    optionNewLine(2, 'Replace two neutral stones with your stones AND replace a different stone of yours on the board to neutral stone'),
    read_digit_bounds(1, 2, Choice),
    retrieve_move_menu_next(Choice, Gamestate, Move).

% retrieve_move_menu_next(+Type, +Gamestate, -Move)
% Redirects player to a menu to chose their move, according to its Type
retrieve_move_menu_next(1, Gamestate, Move) :- first_move_menu(Gamestate, Move).

retrieve_move_menu_next(2, Gamestate, Move) :- second_move_menu(Gamestate, Move).

% first_move_menu(+Gamestate, -Move)
% Reads and constructs a move of the first type (from user input)
first_move_menu(Gamestate, Move):- 
    write('Insert coordinates to place a stone of yours'), newLine,
    write('Column '),
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    length(Board, MaxColumnRowDigit),
    read_column_bounds(1, MaxColumnRowDigit, ColumnNumber),
    digit_to_column(ColumnNumber, ColumnChar),
    write('Line: '),
    read_row_bounds(1, MaxColumnRowDigit, RowNumber),
    format('Chosen coordinates: ~s~d', [ColumnChar, RowNumber]), newLine,
    write('Insert coordinates to place neutral stone'), newLine,
    write('Column '),
    read_column_bounds(1, MaxColumnRowDigit, ColumnNumber_2),
    digit_to_column(ColumnNumber_2, ColumnChar_2),
    write('Line: '),
    read_row_bounds(1, MaxColumnRowDigit, RowNumber_2),
    format('Chosen coordinates: ~s~d', [ColumnChar_2, RowNumber_2]), newLine,
    optionNewLine(1, 'Continue'),
    optionNewLine(2, 'Redo move chosen'),
    read_digit_bounds(1, 2, Choice),
    Move = [pair(pair(RowNumberAdjust, ColumnNumberAdjust), Player), pair(pair(RowNumber_2Adjust, ColumnNumber_2Adjust), 5)],
    RowNumberAdjust is RowNumber - 1, RowNumber_2Adjust is RowNumber_2 - 1, ColumnNumberAdjust is ColumnNumber - 1, ColumnNumber_2Adjust is ColumnNumber_2 - 1,
    first_move_menu_next(Choice, Gamestate, Move).

% first_move_menu_next(+Choice, +Gamestate, -Move)
% Either tries to validate the player's move or gives him the possibility to redo his move, depending on Choice
first_move_menu_next(1, Gamestate, Move):- 
    validate_move(1, Gamestate, Move).

first_move_menu_next(2, Gamestate, Move):- 
    update_game(Gamestate).

% second_move_menu(+Gamestate, -Move)
% Reads and constructs a move of the second type (from user input)
second_move_menu(Gamestate, Move):- 
    write('Insert coordinates of neutral stone to replace with a stone of yours'), newLine,
    write('Column '),
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    length(Board, MaxColumnRowDigit),
    read_column_bounds(1, MaxColumnRowDigit, ColumnNumber),
    digit_to_column(ColumnNumber, ColumnChar),
    write('Line: '),
    read_row_bounds(1, MaxColumnRowDigit, RowNumber),
    format('Chosen coordinates: ~s~d', [ColumnChar, RowNumber]), newLine,
    write('Insert coordinates of another neutral stone to replace with a stone of yours'), newLine,
    write('Column '),
    read_column_bounds(1, MaxColumnRowDigit, ColumnNumber_2),
    digit_to_column(ColumnNumber_2, ColumnChar_2),
    write('Line: '),
    read_row_bounds(1, MaxColumnRowDigit, RowNumber_2),
    format('Chosen coordinates: ~s~d', [ColumnChar_2, RowNumber_2]), newLine,
    write('Insert coordinates of a stone of yours to replace with a neutral stone'), newLine,
    write('Column '),
    read_column_bounds(1, MaxColumnRowDigit, ColumnNumber_3),
    digit_to_column(ColumnNumber_3, ColumnChar_3),
    write('Line: '),
    read_row_bounds(1, MaxColumnRowDigit, RowNumber_3),
    format('Chosen coordinates: ~s~d', [ColumnChar_3, RowNumber_3]), newLine,
    optionNewLine(1, 'Continue'),
    optionNewLine(2, 'Redo move chosen'),
    read_digit_bounds(1, 2, Choice),
    Move = [pair(pair(RowNumberAdjust, ColumnNumberAdjust), Player), pair(pair(RowNumber_2Adjust, ColumnNumber_2Adjust), Player), pair(pair(RowNumber_3Adjust, ColumnNumber_3Adjust), 5)],
    RowNumberAdjust is RowNumber - 1, RowNumber_2Adjust is RowNumber_2 - 1, RowNumber_3Adjust is RowNumber_3 - 1, ColumnNumberAdjust is ColumnNumber - 1, ColumnNumber_2Adjust is ColumnNumber_2 - 1, ColumnNumber_3Adjust is ColumnNumber_3 - 1,
    second_move_menu_next(Choice, Gamestate, Move).

% second_move_menu_next(+Choice, +Gamestate, -Move)
% Either tries to validate the player's move or gives him the possibility to redo his move, depending on Choice
second_move_menu_next(1, Gamestate, Move):- 
    validate_move(2, Gamestate, Move).

second_move_menu_next(2, Gamestate, Move):- 
    update_game(Gamestate).


