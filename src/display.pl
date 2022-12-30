initial_state(1, Difficulty, [
    2, Difficulty, [1,2],
    [
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0]
    ]
]). 

initial_state(2, Difficulty, [
    2, Difficulty, [1,2],
    [
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
    ]
]).

initial_state(3, Difficulty, [
    2, Difficulty, [1,2],
    [
        [0,1,0,0,0,0,0],
        [0,1,1,0,0,0,1],
        [0,0,1,0,0,1,0],
        [0,1,0,0,1,0,0],
        [0,1,1,1,1,0,0],
        [0,0,1,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
]).

initial_state(4, Difficulty, [
    2, Difficulty, [1,2],
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

initial_state(5, Difficulty, [
    2, Difficulty, [1,2],
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
    newLine.

display_stats(Value):- 
    nth0(0, Value, EmptyCount),
    nth0(1, Value, NeutralCount),
    nth0(2, Value, Player1Count),
    nth0(3, Value, Player2Count),
    format('Tiles: Empty ~d Neutral ~d Player1 ~d Player2 ~d',[EmptyCount, NeutralCount, Player1Count, Player2Count]), newLine, newLine.


display_game(Gamestate):- 
    getCurrPlayer(Gamestate, Player),
    display_header(Player),
    value(Gamestate, Value),
    display_stats(Value),
    getCurrWalls(Gamestate, Walls),
    nth0(0, Walls, First),
    nth0(1, Walls, Second),
    format('Vertical ~d horizontal ~d\n',[First, Second]),
    getCurrBoard(Gamestate, Board),
    display_board_header(Board),
    display_board(Board, 0).

display_board([], X):-
    print_spaces(X),
    write('  '),
    print_digits(X),
    newLine.

display_board([H|T], X):- 
    print_spaces(X),
    write('2'),
    print_line(H),
    NewX is X + 1,
    display_board(T, NewX).
    
display_board_header([H|T]):- 
    write(' '),
    print_header_line(H).

print_line([]):- 
    write('  '),
    write('2'),
    newLine.

print_line([H|T]) :- 
    digitToOutput(H, Output),
    write('  '),
    put_code(Output),
    print_line(T).

print_header_line([]):- 
    write('   '),
    newLine.

print_header_line([H|T]) :- 
    write('1'),
    write('  '),
    print_header_line(T).


print_spaces(0) :- !.
print_spaces(X) :-
    X > 0,
    format(' ~w', [' ']),
    X1 is X - 1,
    print_spaces(X1).

print_digits(0) :- !.
print_digits(X) :-
    X > 0,
    write(' 1 '),
    X1 is X - 1,
    print_digits(X1).
