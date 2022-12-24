switch_players(OldPlayer, NewPlayer):- NewPlayer is -1 * OldPlayer.

create_game_state(NewPlayer, Difficulty, NewBoard, [NewPlayer, Difficulty, NewBoard]).


update_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move(Gamestate, Move),
    %write('we are on play\n'),
    %print_valid_moves(Move),
    move(Gamestate, Move, NewGamestate),
    %write('final final final print\n'),
    getCurrBoard(NewGamestate, Board),
    update_game(NewGamestate).


retrieve_move(Gamestate, Move):- 
    %choose_move(Gamestate, Difficulty, Move),
    retrieve_move_menu(Gamestate, Move).


move(Gamestate, [], Gamestate).

move(Gamestate, [CurrMove|NextMove], NewGamestate):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayer(Gamestate, Player),
    getCurrDifficulty(Gamestate, Difficulty),
    %printmove(CurrMove),
    get_move_info(CurrMove, X, Y, P),
    update_matrix(Board, X, Y, P, NewBoard),    
    %display_board(NewBoard),
    %getCurrBoard(NewGameState, Boarde),
    %write('final board\n'),
    %display_board(Boarde),
    (NextMove == [] -> switch_players(Player, NewPlayer) ; NewPlayer = Player),
    create_game_state(NewPlayer, Difficulty, NewBoard, TempGamestate),
    move(TempGamestate, NextMove, NewGamestate).    