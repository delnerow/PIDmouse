function floodval = flood_fill_micromouse(maze, goal, reflood_flag, start)
    % Implementa o algoritmo de preenchimento por inundação (flood fill)
    % para encontrar o caminho ótimo de qualquer célula do labirinto até
    % o objetivo. O algoritmo calcula a distância mínima de cada célula
    % até o objetivo, considerando as paredes do labirinto.
    %
    % PARÂMETROS DE ENTRADA:
    %   maze - Matriz NxN representando o labirinto em formato bitfield
    %          Cada elemento contém bits indicando paredes:
    %          Bit 0 (0x01): Parede Sul, Bit 1 (0x02): Parede Leste
    %          Bit 2 (0x04): Parede Norte, Bit 3 (0x08): Parede Oeste
    %   goal - Vetor [x, y] com coordenadas do objetivo
    %   reflood_flag - Flag booleano indicando se é reflood (true) ou flood inicial (false)
    %   start - Vetor [x, y] com coordenadas de início (usado apenas se reflood_flag=true)
    %
    % PARÂMETROS DE SAÍDA:
    %   floodval - Matriz NxN com valores de distância de cada célula até o objetivo
    %              Células inacessíveis têm valor 255 (LARGEVAL)
    %              O objetivo tem valor 0, células adjacentes têm valor 1, etc.


    % Translated from C logic 
N = size(maze,1);
LARGEVAL = 255;

% Initialize flood values
floodval = LARGEVAL * ones(N,N);

if ~reflood_flag
    % Center goal (for even-sized maze)
    cx = goal(1);
    cy = goal(2);
    goal_cells = [floor(cx),floor(cy); floor(cx),ceil(cy); ceil(cx),floor(cy); ceil(cx),ceil(cy)];
    for k=1:size(goal_cells,1)
        r = goal_cells(k,1); co = goal_cells(k,2);
        if r>=1 && r<=N && co>=1 && co<=N
            floodval(r,co) = 0;
        end
    end
    queue = goal_cells(all(goal_cells>=1 & goal_cells<=N,2),:);
else
    floodval(start(1),start(2)) = 0;
    queue = start;
end

dirvec = [-1 0; 0 1; 1 0; 0 -1]; % N E S W
dirbits = [4 2 1 8];

while ~isempty(queue)
    curr = queue(1,:); queue(1,:) = [];
    r = curr(1); c = curr(2);
    curr_val = floodval(r,c);

    for dir = 1:4
        dr = dirvec(dir,1); dc = dirvec(dir,2);
        nr = r+dr; nc = c+dc;
        if nr<1 || nr>N || nc<1 || nc>N, continue; end
        if bitand(maze(r,c), dirbits(dir)), continue; end
        if floodval(nr,nc) > curr_val+1
            floodval(nr,nc) = curr_val+1;
            queue(end+1,:) = [nr nc];
        end
    end
end
end
