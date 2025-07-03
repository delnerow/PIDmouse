function [xx, yy] = path_to_line(path, cellSize)
     % Caminho -> trajetória contínua usando janelas de 3 células
    % path: [N x 2] matriz [linha, coluna]
    % cellSize: tamanho da célula no mundo real
    % Inicialização
    pts = cell_to_world(path, cellSize);
    N = size(pts, 1);

    % 2. Selecionar pontos-chave (quinas + extremos)
    keep = false(N,1);
    keep(1) = true;
    keep(end) = true;

    for i = 2:N-1
        prev = pts(i-1,:) - pts(i,:);
        next = pts(i+1,:) - pts(i,:);

        if ~isequal(sign(prev), sign(next))
            keep(i) = true; % é quina
        end
    end

    % 3. Gerar spline global com os pontos selecionados
    pts_filtered = pts(keep,:);
    t = 1:size(pts_filtered,1);
    tt = linspace(1, length(t), 10 * length(t));  % mais resolução

    % Spline cúbica com continuidade (catmull-rom-like)
    xx = spline(t, pts_filtered(:,1), tt);
    yy = spline(t, pts_filtered(:,2), tt);

    % 4. Visualização
   % figure;
    plot(xx, yy, 'b-', 'LineWidth', 2);
    %plot(pts(:,1), pts(:,2), 'ro--', 'DisplayName','centros');
    %plot(pts_filtered(:,1), pts_filtered(:,2), 'go', 'MarkerSize', 8, ...
    %    'LineWidth',1.2,'DisplayName','pontos-chave');
    %legend('Trajetória final', 'Células', 'Pontos-chave');
    %title('Spline global suave sem batimentos');
    %axis equal;
    %grid on;
end

function pos = cell_to_world(cells, cellSize)
    % Transforma [linha, coluna] → [x, y] no mundo real (centro da célula)
    x = (cells(:,2) - 0.5) * cellSize;
    y = (16-cells(:,1) + 0.5) * cellSize;
    pos = [x, y];
end

function simplified_path = simplify_path_full(path)
    N = size(path,1);
    if N <= 2
        simplified_path = path;
        return
    end

    simplified_path = path(1,:);  % começa no primeiro ponto
    start_idx = 1;
    current_dir = [];

    for i = 2:N
        v = path(i,:) - path(i-1,:);
        if isempty(current_dir)
            current_dir = v / norm(v);
        else
            v_norm = v / norm(v);
            if norm(v_norm - current_dir) > 1e-10
                % direção mudou, adiciona ponto anterior
                simplified_path = [simplified_path; path(i-1,:)];
                current_dir = v_norm;
                start_idx = i-1;
            end
        end
    end

    % adiciona último ponto
    simplified_path = [simplified_path; path(end,:)];

end
