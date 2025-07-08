function cell = returnCell(N,mouse)
    % Converte as coordenadas reais (x, y) do robô no sistema de coordenadas
    % do mundo para as coordenadas da célula correspondente na matriz do
    % labirinto. Esta função é essencial para mapeamento entre posição
    % contínua e posição discreta no labirinto.
    %
    % PARÂMETROS DE ENTRADA:
    %   N - Dimensão do labirinto (NxN)
    %   mouse - Estrutura contendo posição real do robô:
    %           .x_real - Posição x real do robô no sistema de coordenadas do mundo
    %           .y_real - Posição y real do robô no sistema de coordenadas do mundo
    %
    % PARÂMETROS DE SAÍDA:
    %   cell - Vetor [row, col] com coordenadas da célula no labirinto:
    %          row - Índice da linha na matriz (1 a N)
    %          col - Índice da coluna na matriz (1 a N)


    % retorna célula do labirinto baseada no  arredondamento de x e y do mouse
 row = mod(floor(16-mouse.y_real),N)+1;
 col = mod(floor(mouse.x_real),N)+1;
 cell=[row,col];
end