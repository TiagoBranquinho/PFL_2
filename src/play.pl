% switch_players(+OldPlayer, -NewPlayer)
% Gets the next player to chose a move
switch_players(OldPlayer, NewPlayer):- NewPlayer is -1 * OldPlayer.

% create_game_state(+Player, +Difficulty, +Walls, +Board, -Gamestate)
% Creates a Gamestate in the form [Player, Difficulty, Walls, Board]
create_game_state(NewPlayer, Difficulty, NewWalls, NewBoard, [NewPlayer, Difficulty, NewWalls, NewBoard]).

% game_over(+Gamestate, -Winner)
% Checks if the game was ended according to the predicates to find paths and to the board's walls. If the game has ended, puts the player who won on Winner
game_over(Gamestate, Winner):- 
    getCurrPlayer(Gamestate, Player),
    switch_players(Player, LastPlayer),
    getPlayerChar(LastPlayer, LastPlayerChar),
    getCurrWalls(Gamestate, Walls),
    nth0(0, Walls, VerticalWalls),
    VerticalWalls == LastPlayerChar,
    getCurrBoard(Gamestate, Board),
    matrix_has_path_left_right(Board, LastPlayerChar),
    Winner = LastPlayer.

game_over(Gamestate, Winner):- 
    getCurrPlayer(Gamestate, Player),
    switch_players(Player, LastPlayer),
    getCurrWalls(Gamestate, Walls),
    nth0(1, Walls, HorizontalWalls),
    HorizontalWalls == LastPlayer,
    getCurrBoard(Gamestate, Board),
    matrix_has_path_top_bottom(Board, LastPlayer),
    Winner = LastPlayer.

% update_game(+Gamestate)
% Game cycle. Checks for winners, displays the current player, stats, board, and retrieves and executes players' moves
update_game(Gamestate):-  
    clear,
    game_over(Gamestate, Winner), %checking if someone won the game, if not, it will proceed to next predicate
    getPlayerName(Winner, WinnerName),
    format('~s has won the game!',[WinnerName]), newLine,
    write('This was the final board:'), newLine,
    getCurrBoard(Gamestate, Board),
    value(Gamestate, Value),
    display_stats(Value),
    getCurrBoard(Gamestate, Board),
    getCurrWalls(Gamestate, Walls),
    display_board_header(Board, Walls),
    display_board(Board, Walls, 0),
    readInput,
    menu(3).

update_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move(Gamestate, Move),
    %write('we are on play\n'),
    %print_valid_moves(Move),
    move(Gamestate, Move, NewGamestate),
    %write('final final final print\n'),
    %getCurrBoard(NewGamestate, Board),
    update_game(NewGamestate).

% retrieve_move(+Gamestate, -Move)
% Selects a valid Move, either from the player of from the bot
retrieve_move(Gamestate, Move):- 
    getCurrPlayer(Gamestate, Player),
    getPlayerType(Player, Type),
    getCurrDifficulty(Gamestate, Difficulty),
    %format('Type = ~s\n',[Type]),
    %format('Difficulty is ~d\n',[Difficulty]),
    (Type == 'Player' -> retrieve_move_menu(Gamestate, Move) ; choose_move(Gamestate, Difficulty, Move)).

% move(+Gamestate, +Move, -NewGamestate)
% Executes valid moves from the Move list, changing the Gamestate accordingly (saving the new one in NewGamestate)
move(Gamestate, [], Gamestate).

move(Gamestate, [CurrMove|NextMove], NewGamestate):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayer(Gamestate, Player),
    getCurrDifficulty(Gamestate, Difficulty),
    getCurrWalls(Gamestate, Walls),
    %printmove(CurrMove),
    get_move_info(CurrMove, X, Y, P),
    update_matrix(Board, X, Y, P, NewBoard),    
    %display_board(NewBoard),
    %getCurrBoard(NewGameState, Boarde),
    %write('final board\n'),
    %display_board(Boarde),
    (NextMove == [] -> switch_players(Player, NewPlayer) ; NewPlayer = Player),
    create_game_state(NewPlayer, Difficulty, Walls, NewBoard, TempGamestate),
    move(TempGamestate, NextMove, NewGamestate).    