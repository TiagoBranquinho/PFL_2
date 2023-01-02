# NEX - Turma 2 Grupo 1

## Identificação do trabalho

O jogo desenvolvido é o Nex. https://www.iggamecenter.com/en/rules/nex

- Henrique Oliveira Silva up202007242         (50%)
- Tiago Nunes Moreira Branquinho up202005567  (50%)

## Instalação e Execução

Para jogar o jogo é necessário ter o SICStus Prolog 4.7.1 ou qualquer versão mais recente instalada (https://sicstus.sics.se). Para além disso é necessário ter a pasta com o código fonte.

Abrir a consola do SicStus na root do projeto, através do comando `sicstus`

Para que os ficheiros do jogo sejam lidos, tem de realizar o seguinte comando na consola do SicStus do projeto: `consult('src/main.pl').`

```prolog
?- consult('src/main.pl').
```

Caso esteja a correr pode em alternativa selecionar `File -> Consult...` e selecionar o ficheiro `main.pl`

Após isso, para iniciar o jogo apenas precisa de correr o predicado `play/0`, inserindo `play.` na consola do SicStus

```prolog
?- play.
```


## Descrição do jogo

O Nex é jogado num tabuleiro de pedras em forma de paralelogramo, em que cada par de paredes opostas pertence a um jogador. O objetivo do jogo é formar um caminho entre duas arestas do tabuleiro. Assim, para um jogador sair vitorioso, tem de formar um caminho, conectando as suas duas arestas do tabuleiro com pedras suas.
As pedras podem ser de vários tipos, Vazias(0), Neutras(5), Pertencentes ao jogador 1(1), e Pertencentes ao jogador 2(2).

Na sua vez de jogar, um jogador pode realizar uma de duas jogadas:
- Colocar uma pedra sua e uma pedra neutra em pedras vazias
- Substituir duas pedras neutras por pedras suas, e substituir uma outra pedra sua por uma pedra neutra

Desta forma o primeiro jogador terá sempre vantagem, contudo, para controlar isso, o jogador 2, na sua primeira jogada, tem a possibilidade de inverter as arestas do tabuleiro (trocando de paredes com o primeiro jogador)

## Lógica do jogo

### Representação interna do estado do jogo

#### Tabuleiro

O estado do jogo `gamestate` é representado por uma lista que contém o jogador atual, o nível de dificuldade, as arestas do tabuleiro e o próprio tabuleiro em si, tendo a forma `[Player, Difficulty, Walls, Board]`

- Exemplo de estado de jogo inicial:
- [
    1, 0, [1,2,0],
    [
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
    ]
  ]

- Exemplo de estado de jogo intermédio:
- [
    -1, 0, [1,2,0],
    [
        [0,0,5,1,0],
        [2,2,0,1,5],
        [2,2,5,0,0],
        [0,1,0,2,0],
        [1,0,2,0,1],
    ]
  ]

- Exemplo de estado de jogo final:
- [
    1, 0, [1,2,0],
    [
        [2,1,5,5,1],
        [5,2,1,1,2],
        [5,2,1,0,0],
        [2,1,1,2,2],
        [1,2,2,5,1],
    ]
  ]

  O tabuleiro atual pode ser obtido através do predicado `getCurrBoard/2`
```prolog
getCurrBoard([Player, Difficulty, Walls, Board], Board).
```


#### Jogador

- O jogador no estado do jogo pode ser representado pelos seguintes números: 1, -1, 2, -2, 3, -3.
- Os jogadores 1, -1 e 2 representam jogadores, enquanto os restantes representam computadores.
- Os jogadres de valor absoluto igual a 1 correspondem ao modo de jogo `Player vs Player`
- Os jogadres de valor absoluto igual a 2 correspondem ao modo de jogo `Player vs Bot`
- Os jogadres de valor absoluto igual a 3 correspondem ao modo de jogo `Bot vs Bot`

O jogador atual é trocado através do predicado switch_players/2:

```prolog
switch_players(OldPlayer, NewPlayer):- NewPlayer is -1 * OldPlayer.
```

A representação gráfica do jogador é obtida através do predicado `getPlayerChar/2`
Exemplo:
```prolog
getPlayerChar(-1,2).
```
O jogador é obtido através do predicado `getCurrPlayer/2`
```prolog
getCurrPlayer([Player, Difficulty, Walls, Board], Player).
```
#### Dificuldade

A dificuldade é representadas pelos números 0 (Nula, sendo um jogo sem computadores), 1 (Fácil)

A dificuldade é obtida através dos seguintes predicados:
- `toDifficulty2`
 ```prolog
toDifficulty(1, 'Easy').
```
- `getCurrDifficulty2`
 ```prolog
getCurrDifficulty([Player, Difficulty, Walls, Board], Difficulty).
```
A Dificuldade apenas é escolhida no momento de iniciar o jogo no menu `Player vs Bot` ou `Bot vs Bot`, sendo mantida até ao final do jogo

Esta é utilizada no momento de decisão da dificuldade da jogada do computador, apesar de que apenas está implementado o bot fácil.

#### Arestas

Este campo no estado de jogo é necessário pois o segundo jogador tem a possibilidade de inverter as arestas. O campo arestas é representado por uma lista, tendo a forma `[VerticalWalls, HorizontalWalls, InvertChoiceMade]`.

- O primeiro campo está associado ao dígito referente às arestas verticais
- O segundo campo está associado ao dígito referente às arestas horizontais
- O terceiro campo representa se a escolha de inverter ou não as paredes já foi realizada, podendo ser 0 ou 1


### Visualização do estado de jogo

#### Validação de entrada

A interação feita com o utilizador foi conseguida através de 3 predicados, `read_digit_bounds/3`, `read_row_bounds/3` e `read_column_bounds/3`

 ```prolog
read_digit_bounds(1, 6, Choice).
```
 ```prolog
read_row_bounds(1, 6, Choice).
```
 ```prolog
read_column_bounds(1, 6, Choice).
```
Todos estes predicados informam o jogador sobre o intervalo de escolhas que este pode fazer, forçando-o a escolher uma opção válida entre os limites apresentados, neste caso, 1-6. Caso a opção introduzida pelo utilizador não esteja nesse intervalo o mesmo predicado é chamado, pedindo ao utilizador uma nova opção


O primeiro predicado é usado no sistema de menus, enquanto que os restantes dois são utilizados para ler uma jogada introduzida pelo jogador

#### Sistema de menus

Foram criados alguns predicados que representam menus, como `menu`, `pvp_menu`, `pve_menu`, `bot_vs_bot_menu`, `retrieve_move_menu`, `first_move_menu`, `second_move_menu`, `rules_menu` e `board_size_menu`.

A interação entre menus é assegurada por predicados como `menu_next/2`, que encaminham o flow do programa para outros menus, e, eventualmente, para o começo do jogo.

no predicado menu:
 ```prolog
read_digit_bounds(1, 6, Choice),
menu_next(Choice, BoardSizeOpt).
```
```prolog
menu_next(1, BoardSizeOpt) :- pvp_menu(BoardSizeOpt).
```

#### Estado de jogo

O estado do jogo é visualizado através do predicado `display_game/1`, que imprime várias informações essenciais, como:
- O jogador que está a jogar num determinado momento
- O estado do tabuleiro, que indica a quantidade de pedras de cada tipo
- O tabuleiro em si, junto com as arestas dos dois jogadores

```prolog
% display_game(+Gamestate)
% Prints the current player, the value and the board itself, including its walls
display_game(Gamestate):- 
    getCurrPlayer(Gamestate, Player),
    display_header(Player),
    value(Gamestate, Value),
    display_stats(Value),
    getCurrBoard(Gamestate, Board),
    getCurrWalls(Gamestate, Walls),
    display_board_header(Board, Walls),
    display_board(Board, Walls, 0).
```

O estado de jogo inicial é definido pelo predicado `initial_state/4`, que cria um objeto `gamestate` de acordo com: 
- o tamanho escolhido do tabuleiro
- o jogador inicial
- a dificuldade escolhida
- as arestas iniciais do tabuleiro

Predicado `initial_state/4` para um tamanho de 5x5

```prolog
% initial_state(+Size, +Player, +Difficulty, -Gamestate)
% Constructs a Gamestate object, with the format [Player, Difficulty, Walls, Board], where the Size dictates the board's dimension and the Walls object is [HorizontalWalls, VerticalWalls, InvertChoiceMade]. The last element indicates whether the player 2 chose what to do regarding wall inversion
initial_state(1, Player, Difficulty, [
    Player, Difficulty, [1,2,0],
    [
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0],
        [0,0,0,0,0]
    ]
]). 
```
Após este predicado devolver o estado inicial do jogo, é chamado o predicado `update_game/1`, que inicia o jogo

### Execução de jogadas

A execução de jogadas é possível graças ao predicado `move/3`

Este é recursivo, atualizando o estado de jogo antigo após cada movimento presente numa jogada, sendo uma jogada, `move` composta por uma lista de movimentos, da forma `pair(pair(X,Y),P)`, sendo X e Y as coordenadas da pedra que ficará com o símbolo P

Este predicado faz uso:
- Do predicado `update_matrix/5`, que atualiza o tabuleiro
- Do predicado `switch_players/2`, quando já não existem mais movimentos na jogada
- Do predicado `create_game_state/5`, que cria um novo estado de jogo a cada movimento   

```prolog
% move(+Gamestate, +Move, -NewGamestate)
% Executes valid moves from the Move list, changing the Gamestate accordingly (saving the new one in NewGamestate)
move(Gamestate, [], Gamestate).

move(Gamestate, [CurrMove|NextMove], NewGamestate):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayer(Gamestate, Player),
    getCurrDifficulty(Gamestate, Difficulty),
    getCurrWalls(Gamestate, Walls),
    get_move_info(CurrMove, X, Y, P),
    update_matrix(Board, X, Y, P, NewBoard),    
    (NextMove == [] -> switch_players(Player, NewPlayer) ; NewPlayer = Player),
    create_game_state(NewPlayer, Difficulty, Walls, NewBoard, TempGamestate),
    move(TempGamestate, NextMove, NewGamestate). 
```

#### Validação de jogadas

A validação de jogadas é realizada pelo predicado `validate_move/3`, que, de acordo com o tipo de jogada e com a lista de jogadas válidas de acordo com o estado do jogo, aprova ou não uma jogada. O argumento Move do predicado `move/3` representa sempre uma jogada válida.

No caso de jogadas do `tipo 1`:

- Obter a lista de movimentos válidos
- Verificar se o primeiro movimento pertence a essa lista
- Retirar a essa lista todos os movimentos com coordenadas iguais às do primeiro movimento da jogada
- Retirar a essa lista resultante todos os movimentos que coloquem o mesmo símbolo do primeiro movimento da jogada
- Verificar se o segundo movimento pertence à lista final

No caso de jogadas do `tipo 2`:

- Obter a lista de movimentos válidos
- Verificar se o primeiro movimento pertence a essa lista
- Retirar a essa lista esse movimento
- Verificar se o segundo movimento pertence a essa lista
- Retirar a essa lista resultante esse movimento
- Verificar se o terceiro movimento pertence à lista final

```prolog
% validate_move(+Type, +Gamestate, +Move)
% Checks if a move from type Type is valid
validate_move(1, Gamestate, Move):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    valid_moves(1, 0, Board, Player, ListOfMovesAux),
    flatten_list(ListOfMovesAux, ListOfMoves),
    nth0(0, Move, Move_1),
    member(Move_1, ListOfMoves),
    get_move_info(Move_1, Move_1_X, Move_1_Y, Move_1_P),
    construct_move(Move_1_X, Move_1_Y, Player, Move_1_1),
    construct_move(Move_1_X, Move_1_Y, 5, Move_1_2),
    deleted(Move_1_1, ListOfMoves, NewListOfMoves),
    deleted(Move_1_2, NewListOfMoves, FinalListOfMoves),
    nth0(1, Move, Move_2),
    member(Move_2, FinalListOfMoves).

% If the move wasn't approved, redo the cycle to display the game and retreive the player's move
validate_move(1, Gamestate, Move):- 
    newLine, newLine, write('Your move wasnt approved!'), newLine, newLine,
    update_game(Gamestate).

validate_move(2, Gamestate, Move):- 
    getCurrBoard(Gamestate, Board),
    getCurrPlayerChar(Gamestate, Player),
    valid_moves(2, 0, Board, Player, ListOfMovesAux),
    flatten_list(ListOfMovesAux, ListOfMoves),
    nth0(0, Move, Move_1),
    member(Move_1, ListOfMoves),
    deleted(Move_1, ListOfMoves, NewListOfMoves),
    nth0(1, Move, Move_2),
    printmove(Move_2),
    member(Move_2, NewListOfMoves),
    deleted(Move_2, NewListOfMoves, FinalListOfMoves),
    nth0(2, Move, Move_3),
    member(Move_3, FinalListOfMoves).

% If the move wasn't approved, redo the cycle to display the game and retreive the player's move
validate_move(2, Gamestate, Move):- 
    newLine, newLine, write('Your move wasnt approved!'), newLine, newLine,
    readInput, newLine,
    update_game(Gamestate).
```


### Lista de jogadas válidas

O predicado `valid_moves/5` permite obter a lista de movimentos válidos de acordo com o tipo de jogada e com a linha em que queremos começar a verificar a existência desses movimentos válidos.

O predicado apresentado vai percorrer todo o tabuleiro (a partir da linha selecionada), e no caso de se tratar de uma jogada do `tipo 1`:

- Adicionar à lista de movimentos válidos os movimentos `pair(pair(X,Y),5)` e `pair(pair(X,Y),P)` em que:
- - P é o símbolo do jogador atual
- - X e Y correspondem à linha e coluna de pedras vazias

Caso se tratar de uma jogada do `tipo 2`:

- Adicionar à lista de movimentos válidos os movimentos `pair(pair(X,Y),5)` em que:
- - X e Y correspondem à linha e coluna de pedras do jogador atual

- Adicionar à lista de movimentos válidos os movimentos `pair(pair(X,Y),P)` em que:
- - P é o símbolo do jogador atual
- - X e Y correspondem à linha e coluna de pedras neutras

```prolog
% valid_moves(+Type, +StartingRow, +Matrix, +Player, -ListOfMoves)
% Inserts all valid moves of type Type in ListOfMoves
valid_moves(1, _, [], _, []).

valid_moves(1, Row, [CurrLine|NextLine], Player, [App|ListOfMoves]):- 
    valid_moves_aux(Row, 0, CurrLine, Player, App),
    NewRow is Row + 1,
    valid_moves(1, NewRow, NextLine, Player, ListOfMoves).

valid_moves_aux(_, _, [], _ , []).

valid_moves_aux(Row, Column, [0|T], Player, [pair(pair(Row, Column), Player), pair(pair(Row, Column), 5) | ListOfMoves]):- 
    NewColumn is Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).


valid_moves_aux(Row, Column, [H|T], Player, ListOfMoves):- 
    H \= 0,
    NewColumn is Column + 1,
    valid_moves_aux(Row, NewColumn, T, Player, ListOfMoves).


valid_moves(2, _, [], _, []).

valid_moves(2, Row, [CurrLine|NextLine], Player, [App|ListOfMoves]):- 
    valid_moves_aux_2(Row, 0, CurrLine, Player, App),
    NewRow is Row + 1,
    valid_moves(2, NewRow, NextLine, Player, ListOfMoves).

valid_moves_aux_2(_, _, [], _ , []).

valid_moves_aux_2(Row, Column, [5|T], Player, [pair(pair(Row, Column), Player) | ListOfMoves]):- 
    NewColumn is Column + 1,
    valid_moves_aux_2(Row, NewColumn, T, Player, ListOfMoves).

valid_moves_aux_2(Row, Column, [Player|T], Player, [pair(pair(Row, Column), 5) | ListOfMoves]):- 
    NewColumn is Column + 1,
    valid_moves_aux_2(Row, NewColumn, T, Player, ListOfMoves).

valid_moves_aux_2(Row, Column, [H|T], Player, ListOfMoves):- 
    NewColumn is Column + 1,
    valid_moves_aux_2(Row, NewColumn, T, Player, ListOfMoves).
```


### Final do jogo

O final do jogo é avaliado pelo predicado `game_over/2`, que se verifica caso tenha sido encontrado um vencedor. 

```prolog
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
```

Este predicado irá recorrer a um de dois predicados:

- `matrix_has_path_left_right/2`, que verifica se existe um caminho que liga a aresta da esquerda à aresta da direita

- `matrix_has_path_top_bottom/2`, que verifica se existe um caminho que liga a aresta de cima à aresta de baixo

A escolha do predicado escolhido irá depender do jogador que acabou de jogar e da posição das suas paredes.

Ambos os predicados mencionados consistem em funções recursivas de path finding. As direções em que é efetuada a procura, devido à forma hexagonal das pedras, são:
- Cima
- Baixo
- Esquerda
- Direita
- Diagonal Cima Direita
- Diagonal Baixo Esquerda

### Avaliação do tabuleiro

É realizada pelo predicado `value/2`, que conta o número de pedras existentes de cada tipo. Este predicado recorre a uma função auxiliar que conta o número de pedras no tabuleiro de acordo com o seu símbolo. Por fim, o valor do tabuleiro assume a seguinte forma: `[EmptyCount, NeutralCount, Player1Count, Player2Count]`

```prolog
% value(+Gamestate, -Value)
% Get the amount of empty, neutral, player 1's and player 2's tiles from the Gamestate
value(Gamestate, Value):- 
    getCurrBoard(Gamestate, Board),
    count_element_in_matrix(Board, 0, EmptyCount),
    count_element_in_matrix(Board, 5, NeutralCount),
    count_element_in_matrix(Board, 1, Player1Count),
    count_element_in_matrix(Board, 2, Player2Count),
    Value = [EmptyCount, NeutralCount, Player1Count, Player2Count].
```

### Jogada do computador

A jogada do computador é escolhida pelo predicado `choose_move/3`, de acordo com a dificuldade escolhida. Neste caso, apenas a dificuldade fácil foi implementada.

Em primeiro lugar, é escolhido um número aleatório entre 1 e 2, de forma a que a primeira jogada que o bot tente realizar seja aleatória. Em seguida, o bot tenta realizar essa jogada, escolhendo aleatoriamente movimentos desta, à medida que vai modificando a nova lista de movimentos possiveis até obter uma jogada.

Caso o tipo de jogada escolhido não seja possível o bot tentará realizar uma jogada do outro tipo.