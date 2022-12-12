switch_players(OldPlayer, NewPlayer):- NewPlayer is -OldPlayer.

update_game(Gamestate) :- 
    display_game(Gamestate),
    retrieve_move(Gamestate, Move).
    %move(Gamestate, Move, NewGameState).


retrieve_move(Gamestate, Move):- 
    retrieve_move_menu(Gamestate, Move).

move(Gamestate, Move, NewGamestate) :-
    newLine.

