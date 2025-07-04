function [path, ordens] = stack_caminho(floodval, maze, start)
    % floodval: matriz de custo
    % maze: matriz das paredes, mesma lógica do flood_fill_micromouse
    % start: [row, col] inicial do mouse
    N = size(floodval,1);
    dirvec = [-1 0; 0 1; 1 0; 0 -1]; % N E S W
    dirbits = [4 2 1 8];

    path = start; % inicializa caminho com o ponto inicial
    ordens = []; % inicia lista vazia de ordens

    current = start;
    dir_atual=3;
    while floodval(current(1), current(2)) ~= 0
        r = current(1);
        c = current(2);
        curr_val = floodval(r,c);

        neighbors = [];
        vals = [];
        dirs_vizinhos = [];

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
        if abs(delta_dir) == 3, delta_dir= delta_dir/(-3); end
        ordens(end+1) = delta_dir;
        dir_atual = prox_dir; % atualiza direção

        current = neighbors(idx, :);
        path = [path; current];
    end

end
