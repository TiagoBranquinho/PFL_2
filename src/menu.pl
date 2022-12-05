menuHeaderText(Text) :- format('~n~`*t ~p ~`*t~57|~n', [Text]).


pvpMenu(BoardSizeOpt) :-
    optionNewLine(1, 'PLAY'),
    optionNewLine(2, 'GO BACK'),
    readDigitBounds(1, 3, Choice).


pveMenu(BoardSizeOpt, DifficultyOpt) :-
    optionNewLine(1, 'PLAY'),
    option(2, 'ADJUST DIFFICULTY'),
    toDifficulty(BoardSizeOpt, BoardSize),
    format('Current = ~d: ', [BoardSize]),
    optionNewLine(2, 'GO BACK'),
    readDigitBounds(1, 3, Choice).

rulesMenu :-
    write('THE RULES ARE PRETTY SIMPLE\n\n'),
    option(1, 'GO BACK'),
    readDigitBounds(1, 1, Choice),
    rulesMenuNext(Choice).

mainMenuNext(1, BoardSizeOpt, Difficulty) :- pvpMenu(BoardSizeOpt).

mainMenuNext(2, BoardSizeOpt, Difficulty) :- pveMenu(BoardSizeOpt, Difficulty).

mainMenuNext(3, BoardSizeOpt, Difficulty) :- rulesMenu.

mainMenuNext(4, BoardSizeOpt, Difficulty) :- boardSizeMenu.

mainMenuNext(5, BoardSizeOpt, Difficulty) :- halt(0).

pvpMenuNext(1, BoardSizeOpt) :-    
    initial_state(BoardSizeOpt, Gamestate),
    start_game(Gamestate).

rulesMenuNext(1, BoardSizeOpt, Difficulty) :- menu(BoardSizeOpt, Difficulty).

newLine :- write('\n').

optionNewLine(Number, Text) :-
    format('~d - ~s', [Number, Text]),
    newLine.

option(Number, Text) :-
    format('~d - ~s', [Number, Text]).

boardSizeMenu :- 
    optionNewLine(1, '7x7'),
    optionNewLine(2, '9x9'),
    optionNewLine(3, '11x11'),
    optionNewLine(4, '13x13'),
    readDigitBounds(1, 4, BoardSizeOpt),
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
    format('Current = ~d: ', [BoardSize]),
    newLine,
    optionNewLine(5, 'QUIT'),
    readDigitBounds(1, 5, Choice),
    mainMenuNext(Choice, BoardSizeOpt, Difficulty).

    



