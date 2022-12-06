switch_players(OldPlayer, NewPlayer):- NewPlayer is -OldPlayer.

start_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move_menu(Move).

retrieve_move_menu(Move) :-
    write('Choose your move'),
    newLine,
    optionNewLine(1, 'Place a stone AND a neutral one on empty cells'),
    optionNewLine(2, 'Replace two neutral stones with your stones AND replace a different stone of yours on the board to neutral stone'),
    readDigitBounds(1, 2, Choice),
    retrieve_move_menu_next(Choice, Move).

retrieve_move_menu_next(1, Move) :- first_move_menu(Move).

retrieve_move_menu_next(2, Move) :- second_move_menu(Move).

first_move_menu(Move):- 
    write('Insert coordinates to place stone: '),
    read_line_to_string(Stream, String).

move(Gamestate, Move, NewGamestate) :-
    newLine.

