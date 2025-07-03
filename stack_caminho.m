function path = stack_caminho(floodval, maze, start)
    % floodval: matriz de custo
    % maze: matriz das paredes, mesma lógica do flood_fill_micromouse
    % start: [row, col] inicial do mouse
    N = size(floodval,1);
    dirvec = [-1 0; 0 1; 1 0; 0 -1]; % N E S W
    dirbits = [4 2 1 8];

    path = start; % inicializa caminho com o ponto inicial
    current = start;

    while floodval(current(1), current(2)) ~= 0
        r = current(1);
        c = current(2);
        curr_val = floodval(r,c);

        neighbors = [];
        vals = [];

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
        end

        % Seleciona o vizinho com menor valor
        [min_val, idx] = min(vals);

        if min_val >= curr_val
            error('Não foi possível encontrar caminho para meta');
        end

        current = neighbors(idx, :);
        path = [path; current];
    end
end
