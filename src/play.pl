switch_players(OldPlayer, NewPlayer):- NewPlayer is -OldPlayer.

start_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move(Move).


retrieve_move(Move):- 
    retrieve_move_menu(Move).

move(Gamestate, Move, NewGamestate) :-
    newLine.

