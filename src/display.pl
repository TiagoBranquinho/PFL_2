initial_state(1, [
    1,
    [
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0]
    ]
]). 

initial_state(2, [
    1,
    [
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
    ]
]).

initial_state(3, [
    1,
    [
        [0,0,0,1,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
]).

initial_state(4, [
    1,
    [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]
]).

initial_state(5, [
    1,
    [
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0]
    ]
]).

display_header(Player):- 
    getPlayerName(Player, PlayerName),
    format('~s\'s turn\n', [PlayerName]),
    newLine, newLine.


display_game(Gamestate):- 
    getCurrPlayer(Gamestate, Player),
    display_header(Player),
    getCurrBoard(Gamestate, Board),
    display_board(Board, 0).

display_board([], _):-
    newLine.

display_board([H|T], X):- 
    print_spaces(X),
    print_line(H),
    NewX is X + 1,
    display_board(T, NewX).
    

print_line([]):- 
    write(' '),
    newLine.

print_line([H|T]) :- 
    digitToOutput(H, Output),
    write('  '),
    put_code(Output),
    print_line(T).


print_spaces(0) :- !.
print_spaces(X) :-
    X > 0,
    format(' ~w', [' ']),
    X1 is X - 1,
    print_spaces(X1).
