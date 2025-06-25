% Micromouse Maze Simulation with Flood Fill Integration
% Uses bitfield maze encoding, flood fill logic, and dynamic wall checking.

function micro()
    % Maze in bitfield format (1D, row-major order, uint8).
    % Wall bits: 0x08=West, 0x01=South, 0x02=East, 0x04=North
    
    maze_grid=load_maze_bin("Japan2013eq.maz");

    %Start and goal definitions
    start = [1,1];    % [row, col]
    goal = [8,8];   % [row, col]
    N=size(maze_grid,1);

    % Inicialização do robô
    mouse = struct();
    mouse.theta = 0;         % orientação (rad)
    mouse.vL = 0;            % velocidade da roda esquerda (m/s)
    mouse.vR = 0;            % velocidade da roda direita (m/s)
    mouse.L = 0.1;           % distância entre rodas (m)
    mouse.dir = 3;           % 1=up, 2=right, 3=down, 4=left
    mouse.cell=start;        % celula da matriz q ele esta
    mouse.x = mouse.cell(2)-0.5;            % posição x
    mouse.y = 16-mouse.cell(1)+0.5;         % posição y

    % figura dos plots
    figure('Position', [20, 20, 700, 700]); % [left, bottom, width, height];
    clf;
    
    % bizurando o floofill e contagem de passos
    step = 0;
    floodval = flood_fill_micromouse(maze_grid, goal, 0, start);

    % plotando o mapa
    visualize_maze_bitfield(maze_grid, goal, floodval);

    % plotando mouse pela primeira vez
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir,1)*arrow_length;
    dy = dir_vectors(mouse.dir,2)*arrow_length;
    hold on;
    h_mouse = plot(mouse.x, mouse.y, 'ro', 'MarkerSize', 16, 'MarkerFaceColor', 'r');
    h_arrow = quiver(mouse.x,  mouse.y, dx, dy, 0, 'k', 'LineWidth', 2, 'MaxHeadSize',0.8);
    hold off;
    
    % Main Loop
    while ~isequal(mouse.cell, goal)

        % Visualize mouse
        visualize_mouse(N,mouse,h_mouse, h_arrow)

        % Decide next move: pick neighbor with lowest flood value
        next_dir = get_smallest_neighbor_dir(floodval, maze_grid, mouse.cell, mouse.dir);

        % Move to that cell
        [dr, dc] = dir2vec(next_dir);
        new_pos = mouse.cell + [dr, dc];
        mouse.cell = new_pos;
        mouse.dir = next_dir;
        step = step + 1;
        mouse.x = mouse.cell(2)-0.5;             % posição x
        mouse.y = 16-mouse.cell(1)+0.5;          % posição y
        
        pause(0.05);
    end

    % Final visualization
    floodval = flood_fill_micromouse(maze_grid, goal, 0, start);
    visualize_maze_bitfield(maze_grid, goal, floodval);
    title(sprintf('Goal Reached in %d steps!',step));
end

function dir = get_smallest_neighbor_dir(floodval, maze, pos, preferred_dir)
    N = size(maze,1);
    % lmebrando, row e col, NAO  EH X E Y
    dirvec = [-1 0; 0 1; 1 0; 0 -1]; % N E S W
    dirbits = [4 2 1 8];
    minval = inf;
    candidates = [];

    % Testando todos os lados
    for d = 1:4
        nr = pos(1)+dirvec(d,1); nc = pos(2)+dirvec(d,2);
        if nr<1 || nr>N || nc<1 || nc>N, continue; end

        % ignorar direções com parede
        if bitand(maze(pos(1),pos(2)), dirbits(d)), continue; end
        val = floodval(nr,nc);
        if val < minval
            minval = val;
            candidates(end+1) = d;
        end
    end
    % Fds?
    if ismember(preferred_dir, candidates)
        dir = preferred_dir;
    else
        dir = candidates(end);
    end
end

% claro q n existe função pronta disso
function [dr,dc] = dir2vec(dir)
    vecs = [-1 0; 0 1; 1 0; 0 -1]; % up, right, down, left
    dr = vecs(dir,1); dc = vecs(dir,2);
end


% atualiza posição no plot
function visualize_mouse(N, mouse, h_mouse, h_arrow)
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir,1)*arrow_length;
    dy = dir_vectors(mouse.dir,2)*arrow_length;
    set(h_mouse, 'XData', mouse.x, 'YData',  mouse.y);
    set(h_arrow, 'XData', mouse.x, 'YData',  mouse.y, 'UData', dx, 'VData', dy);
    drawnow;
end

function visualize_maze_bitfield(maze, goal, floodval)
N = size(maze,1);
cell_size_cm=18;
clf; hold on;
for r = 1:N
    for c = 1:N
        x = c-1; y = N-r;
        cell_byte = maze(r,c);
        if bitand(cell_byte,4), plot([x,x+1],[y+1,y+1],'k-','LineWidth',2); end % North
        if bitand(cell_byte,2), plot([x+1,x+1],[y,y+1],'k-','LineWidth',2); end % East
        if bitand(cell_byte,1), plot([x,x+1],[y,y],'k-','LineWidth',2); end   % South
        if bitand(cell_byte,8), plot([x,x],[y,y+1],'k-','LineWidth',2); end   % West
        % Optionally, show flood value in each cell:
        text(x+0.5,y+0.5,num2str(floodval(r,c)),'Color',[0.5 0.5 1],'FontSize',8,'HorizontalAlignment','center');
    end
end
% plot goal
gx = goal(2)-0.5; gy = N-goal(1)+0.5;
plot(gx, gy, 'gs', 'MarkerSize', 18, 'MarkerFaceColor', 'g');

axis equal off;
xlim([-0.5,N+0.5]); ylim([-0.5,N+0.5]);
xlabel('X (cm)');
ylabel('Y (cm)');
set(gca, 'XTick', 0:N, 'XTickLabel', 0:cell_size_cm:cell_size_cm*N);
set(gca, 'YTick', 0:N, 'YTickLabel', 0:cell_size_cm:cell_size_cm*N);
title(sprintf('Micromouse Maze (%dx%d cells, %dx%d cm each)', N, N, cell_size_cm, cell_size_cm));
hold off;
drawnow;
end