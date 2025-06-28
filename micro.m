% Micromouse Maze Simulation with Flood Fill Integration
% Uses bitfield maze encoding, flood fill logic, and dynamic wall checking.

function micro()
    % Maze in bitfield format (1D, row-major order, uint8).
    % Wall bits: 0x08=West, 0x01=South, 0x02=East, 0x04=North
    
    maze_grid=load_maze_bin("mazes/Japan2013eq.maz");

    % Célular de partida e célula objetivo
    start = [1,1];    % [row, col]
    goal = [8,8];   % [row, col]
    N=size(maze_grid,1);

    % Inicialização do robô
    % Constantes
    mouse = struct();
    mouse.L = 0.1;                  % distância entre rodas (1/18 cm)
    mouse.v_base=0.2;               % velocidade padrão, inutilizada por enquanto
    % Variáveis
    mouse.distancia_acumulada = 0;  % um odometro resetado a cada célular
    mouse.vL = 0;                   % velocidade da roda esquerda (m/s)
    mouse.vR = 0;                   % velocidade da roda direita (m/s)
    mouse.theta = 3*pi/2;           % orientação (rad)
    mouse.dir = 2;                  % 0=up, 1=right, 2=down, 3=left, pra onde ele precisa facear no momento (global)
    mouse.cell=start;               % celula da matriz q ele esta
    mouse.rot = 0;                  % 0=reto, 1=giraDireita, -1; giraEsquerda
    mouse.x = mouse.cell(2)-0.5;    % posição x
    mouse.y = 16-mouse.cell(1)+0.5; % posição y
    

    % Obter paredes para os sensores funcionarem (mas os sensores nn tem
    % uso ainda
    paredes = obterParedes(maze_grid);

    % figura da animação
    figure('Position', [820, 0, 700, 700]); % [left, bottom, width, height];
    
    % bizurando o floofill e contagem de passos do maze_grid
    floodval = flood_fill_micromouse(maze_grid, goal, 0, start);

    % plotando o mapa
    visualize_maze_bitfield(maze_grid, goal, floodval);

    % Plotando mouse pela primeira vez
    % seta indicando onde o robo deve facear, a dir
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir+1,1)*arrow_length;
    dy = dir_vectors(mouse.dir+1,2)*arrow_length;
    hold on;
    % bolinha vermelha do robo. sem correalção com seu tamanho
    h_mouse = plot(mouse.x, mouse.y, 'ro', 'MarkerSize', 16, 'MarkerFaceColor', 'r');
    h_arrow = quiver(mouse.x,  mouse.y, dx, dy, 0, 'k', 'LineWidth', 2, 'MaxHeadSize',0.8);
    % Plotar raio do sensor
    h_ray_f = plot([mouse.x mouse.x], [mouse.y mouse.y], 'r--'); % frente
    h_ray_d = plot([mouse.x mouse.x], [mouse.y mouse.y], 'b--'); % direita
    h_ray_e = plot([mouse.x mouse.x], [mouse.y mouse.y], 'g--'); % esquerda
    hold off;
    
    % Main Loop
    dt=0;
    tic;
    while ~isequal(mouse.cell, goal)

        % Visualize mouse
        visualize_mouse(mouse,h_mouse, h_arrow)
        % Reta do sensor 
        % Sensor frente
        dist_f = sensorLeitura(mouse, paredes, 'frente');
        xf = mouse.x + dist_f * cos(mouse.theta);
        yf = mouse.y + dist_f * sin(mouse.theta);
        set(h_ray_f, 'XData', [mouse.x xf], 'YData', [mouse.y yf]);
        
        % Sensor direita
        dist_d = sensorLeitura(mouse, paredes, 'direita');
        xd = mouse.x + dist_d * cos(mouse.theta - pi/2);
        yd = mouse.y + dist_d * sin(mouse.theta - pi/2);
        set(h_ray_d, 'XData', [mouse.x xd], 'YData', [mouse.y yd]);
        
        % Sensor esquerda
        dist_e = sensorLeitura(mouse, paredes, 'esquerda');
        xe = mouse.x + dist_e * cos(mouse.theta + pi/2);
        ye = mouse.y + dist_e * sin(mouse.theta + pi/2);
        set(h_ray_e, 'XData', [mouse.x xe], 'YData', [mouse.y ye]);

        % Enviar dados pra MEF síncrona e ver receber as velocidades
        % comandadas
        curCell = returnCell(N,mouse);
        comandos = mef(curCell,mouse,floodval,maze_grid,paredes);
        mouse.vR = comandos.velocidades.R;
        mouse.vL = comandos.velocidades.L;
        mouse.cell = comandos.cell;
        mouse.rot = comandos.rot;
        mouse.dir = comandos.dir;
        mouse.distancia_acumulada = comandos.ac;
    
        % Mexendo o mouse de fato (e na animação)
        % --- CINEMÁTICA DIFERENCIAL ---
        v_media = (mouse.vR + mouse.vL) / 2;
        w_mouse = (mouse.vR - mouse.vL) / mouse.L;
        mouse.x = mouse.x + v_media * cos(mouse.theta) * dt;
        mouse.y = mouse.y + v_media * sin(mouse.theta) * dt;
        mouse.theta = mod(mouse.theta + w_mouse * dt,2*pi);

        % tempos de frame e da precisão simulação
        pause(0.001);
        dt=dt+0.001;
    end

    % Final visualization
    visualize_maze_bitfield(maze_grid, goal, floodval);
    title(sprintf('Terminou em %f segundos!',toc));
end

% retorna célula baseada no  arredondamento de x e y do mouse
function cell = returnCell(N,mouse)
 row = mod(floor(16-mouse.y),N)+1;
 col = mod(floor(mouse.x),N)+1;
 cell=[row,col];
end

% atualiza posição no plot
function visualize_mouse(mouse, h_mouse, h_arrow)
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir+1,1)*arrow_length;
    dy = dir_vectors(mouse.dir+1,2)*arrow_length;
    set(h_mouse, 'XData', mouse.x, 'YData',  mouse.y);
    set(h_arrow, 'XData', mouse.x, 'YData',  mouse.y, 'UData', dx, 'VData', dy);
    
    drawnow;
end

% plota o mapa com paredes e etc
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
    title(sprintf('Micromouse Maze (%dx%d cells, %dx%d cm cada)', N, N, cell_size_cm, cell_size_cm));
    hold off;
    drawnow;
end

function paredes = obterParedes(maze)
    N = size(maze,1);
    paredesV=[];
    paredesH=[];
    clf; hold on;
    for r = 1:N
        for c = 1:N
            x = c-1; y = N-r;
            cell_byte = maze(r,c);
            if bitand(cell_byte,4), paredesH(end+1, :)=[y+1;x;x+1]; end % North
            if bitand(cell_byte,2), paredesV(end+1, :)=[x+1;y;y+1]; end % East
            if bitand(cell_byte,1), paredesH(end+1, :)=[y;x;x+1]; end   % South
            if bitand(cell_byte,8), paredesV(end+1, :)=[x;y;y+1]; end   % West
        end
    end
    paredes.V=paredesV;
    paredes.H=paredesH;
end

