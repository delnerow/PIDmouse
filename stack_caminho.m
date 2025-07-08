function [path, ordens] = stack_caminho(floodval, maze, start)
    % Converte o resultado do algoritmo de flood fill em uma sequência
    % de comandos discretos que o robô pode executar. A função encontra
    % o caminho ótimo do ponto inicial até o objetivo, seguindo sempre
    % a direção de menor valor no flood fill.
    %
    % PARÂMETROS DE ENTRADA:
    %   floodval - Matriz NxN com valores de distância calculados pelo flood fill
    %              Valores menores indicam células mais próximas do objetivo
    %   maze - Matriz NxN representando o labirinto em formato bitfield
    %          Cada elemento contém bits indicando paredes:
    %          Bit 0 (0x01): Parede Sul, Bit 1 (0x02): Parede Leste
    %          Bit 2 (0x04): Parede Norte, Bit 3 (0x08): Parede Oeste
    %   start - Vetor [row, col] com coordenadas do ponto inicial
    %
    % PARÂMETROS DE SAÍDA:
    %   path - Matriz Mx2 com sequência de células visitadas [row, col]
    %          Cada linha representa uma célula no caminho do início ao objetivo
    %   ordens - Vetor com comandos discretos para o robô:
    %            -1: Girar à esquerda (90°)
    %             0: Seguir em frente
    %             1: Girar à direita (90°)

    % floodval: matriz de custo
    % maze: matriz das paredes, mesma lógica do flood_fill_micromouse
    % start: [row, col] inicial do mouse

    % Dimensão
    N = size(floodval,1);

    % Vetor de cada direção (row x col)
    dirvec = [-1 0; 0 1; 1 0; 0 -1]; % N E S W

    % Bits de cada parede no HEX
    dirbits = [4 2 1 8];

    path = start;   % inicializa caminho com o ponto inicial
    ordens = [];    % inicia lista vazia de ordens

    current = start;  % célula atual
    dir_atual=3;      % direção atual (N E S W)
    while floodval(current(1), current(2)) ~= 0  % Enquanto não chegar em goal
        r = current(1); %row
        c = current(2); %col
        curr_val = floodval(r,c);

        neighbors = []; 
        vals = [];
        dirs_vizinhos = [];

        % testando todas as direções
        for dir = 1:4
            dr = dirvec(dir,1);
            dc = dirvec(dir,2);
            nr = r+dr;
            nc = c+dc;

            % Verifica limites
            if nr < 1 || nr > N || nc < 1 || nc > N
                continue;
            end

            % Verifica parede
            if bitand(maze(r,c), dirbits(dir))
                continue;
            end
            
            % Encontrando vizinhos que satisfaçam tudo acima
            neighbors = [neighbors; nr nc];
            vals = [vals; floodval(nr,nc)];
            dirs_vizinhos = [dirs_vizinhos dir];
        end

        % Seleciona o vizinho com menor valor
        [min_val, idx] = min(vals);

        if min_val >= curr_val
            error('Não foi possível encontrar caminho para meta');
        end
        prox_dir = dirs_vizinhos(idx);
        delta_dir = prox_dir-dir_atual ;           % 0=reto, 1=giraDireita, -1; giraEsquerda

        % existe um descontinuidade do W->N, delta_dir fica +-3
        if abs(delta_dir) == 3, delta_dir= delta_dir/(-3); end
        
        ordens(end+1) = delta_dir;
        dir_atual = prox_dir; % atualiza direção
        current = neighbors(idx, :);
        path = [path; current];
    end

end
