switch_players(OldPlayer, NewPlayer):- NewPlayer is -1 * OldPlayer.

create_game_state(NewPlayer, NewBoard, [NewPlayer, NewBoard]).


update_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move(Gamestate, Move),
    %print_valid_moves(Move),
    nth0(0, Move, FirstMove),
    nth0(1, Move, SecondMove),
    move(Gamestate, FirstMove, NewGamestate),
    move(NewGamestate, SecondMove, LastGamestate),
    update_game(LastGamestate).


retrieve_move(Gamestate, Move):- 
    retrieve_move_menu(Gamestate, Move).


move(Gamestate, CurrMove, NewGamestate):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayer(Gamestate, Player),
    %printmove(CurrMove),
    get_move_info(CurrMove, X, Y, P),
    update_matrix(Board, X, Y, P, NewBoard),    
    %display_board(NewBoard),
    create_game_state(NewPlayer, NewBoard, NewGamestate).
