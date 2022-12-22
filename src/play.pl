switch_players(OldPlayer, NewPlayer):- NewPlayer is -1 * OldPlayer.

create_game_state(NewPlayer, NewBoard, [NewPlayer, NewBoard]).


update_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move(Gamestate, Move),
    %print_valid_moves(Move),
    move(Gamestate, Move, NewGamestate),
    write('final final final print\n'),
    getCurrBoard(NewGamestate, Board),
    display_board(Board).
    %update_game(Gamestate).


retrieve_move(Gamestate, Move):- 
    retrieve_move_menu(Gamestate, Move).


move(Gamestate, [], Gamestate).


move(Gamestate, [CurrMove|NextMove], NewGamestate):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayer(Gamestate, Player),
    %printmove(CurrMove),
    get_move_info(CurrMove, X, Y, P),
    update_matrix(Board, X, Y, P, NewBoard),    
    %display_board(NewBoard),
    create_game_state(Player, NewBoard, TempGamestate),
    %getCurrBoard(NewGameState, Boarde),
    %write('final board\n'),
    %display_board(Boarde),
    move(TempGamestate, NextMove, NewGamestate).    