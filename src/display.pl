menuHeaderText(Text) :- format('~n~`*t ~p ~`*t~57|~n', [Text]).

newLine :- write('\n').

optionNewLine(Number, Text) :-
    option(Number, Text),
    newLine.

option(Number, Text) :-
    format('~d - ~s', [Number, Text]).

initial_state(1, Player, Difficulty, [
    Player, Difficulty, [1,2],
    [
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0]
    ]
]). 

initial_state(2, Player, Difficulty, [
    Player, Difficulty, [1,2],
    [
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
    ]
]).

initial_state(3, Player, Difficulty, [
    Player, Difficulty, [1,2],
    [
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
]).

initial_state(4, Player, Difficulty, [
    Player, Difficulty, [1,2],
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

initial_state(5, Player, Difficulty, [
    Player, Difficulty, [1,2],
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
    %format('Vertical ~d horizontal ~d\n',[First, Second]),
    getCurrBoard(Gamestate, Board),
    getCurrWalls(Gamestate, Walls),
    display_board_header(Board, Walls),
    display_board(Board, Walls, 0).

display_board([], [VerticalWall, HorizontalWall],X):-
    print_spaces(X),
    write('  '),
    print_digits(X, HorizontalWall),
    newLine.

display_board([H|T], [VerticalWall, HorizontalWall], X):- 
    print_spaces(X),
    format('~d',[VerticalWall]),
    print_line(H, VerticalWall),
    NewX is X + 1,
    display_board(T, [VerticalWall, HorizontalWall], NewX).
    
display_board_header([H|T], [VerticalWall, HorizontalWall]):- 
    write(' '),
    print_header_line(H, HorizontalWall).

print_line([], VerticalWall):- 
    write('  '),
    format('~d',[VerticalWall]),
    newLine.

print_line([H|T], VerticalWall) :- 
    digitToOutput(H, Output),
    write('  '),
    put_code(Output),
    print_line(T, VerticalWall).

print_header_line([], HorizontalWall):- 
    write('   '),
    newLine.

print_header_line([H|T], HorizontalWall) :- 
    format('~d',[HorizontalWall]),
    write('  '),
    print_header_line(T, HorizontalWall).


print_spaces(0) :- !.
print_spaces(X) :-
    X > 0,
    format(' ~w', [' ']),
    X1 is X - 1,
    print_spaces(X1).

print_digits(0, HorizontalWall) :- !.
print_digits(X, HorizontalWall) :-
    X > 0,
    format(' ~d ',[HorizontalWall]),
    X1 is X - 1,
    print_digits(X1, HorizontalWall).
