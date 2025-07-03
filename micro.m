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
    mouse.wheel = 0.01;               % Tamanho da roda!
    mouse.L = 16/18;                  % distância entre rodas (1:18 cm)
    mouse.v_base=0.2;               % velocidade padrão, inutilizada por enquanto
    % Variáveis
    mouse.distancia_acumulada = 0;  % um odometro resetado a cada célular
    mouse.vL = 0;                   % velocidade da roda esquerda (m/s)
    mouse.vR = 0;                   % velocidade da roda direita (m/s)
    mouse.theta = -pi/2;           % orientação (rad)
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
    hold on;
    % bizurando o floofill e contagem de passos do maze_grid
    floodval = flood_fill_micromouse(maze_grid, goal, 0, start);
    
    %[xx, yy] = path_to_line(path, 1);
    % plotando o mapa
    visualize_maze_bitfield(maze_grid, goal, floodval);
    path = stack_caminho(floodval,maze_grid,start);

    % Plotando mouse pela primeira vez
    % seta indicando onde o robo deve facear, a dir
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir+1,1)*arrow_length;
    dy = dir_vectors(mouse.dir+1,2)*arrow_length;
   % hold on;
    
    % bolinha vermelha do robo. sem correalção com seu tamanho
    h_mouse = plot(mouse.x, mouse.y, 'ro', 'MarkerSize', 15, 'MarkerFaceColor', 'r');
    h_arrow = quiver(mouse.x,  mouse.y, dx, dy, 0, 'k', 'LineWidth', 2, 'MaxHeadSize',0.8);
    % Plotar raio do sensor
    h_ray_f = plot([mouse.x mouse.x], [mouse.y mouse.y], 'r--'); % frente
    h_ray_d = plot([mouse.x mouse.x], [mouse.y mouse.y], 'b--'); % direita
    h_ray_e = plot([mouse.x mouse.x], [mouse.y mouse.y], 'g--'); % esquerda
   % hold off;
    
    % Main Loop
    dt=0;
    tic;

    % Inicializa controlador híbrido
    ctrl = PIDlookahead(); % lookahead 30 unidades
    [xx, yy] = path_to_line(path, 1);

    while ~isequal(mouse.cell, goal)

        % Visualize mouse
        visualize_mouse(mouse,h_mouse, h_arrow);
        % Reta do sensor 
        visualize_ray(mouse,paredes,h_ray_f,h_ray_d,h_ray_e);
        fprintf("(x) e (y) e(theta) :%f,%f  %f \n",mouse.x,mouse.y,mouse.theta/pi*180);
        % Enviar dados pra MEF síncrona e ver receber as velocidades
        % comandadas
        curCell = returnCell(N,mouse);
        %comandos = mef(curCell,mouse,floodval,maze_grid,paredes);
        [v, omega, ctrl] = ctrl.update(mouse, xx, yy, 0.001);
        %mouse = mouse_update(mouse,comandos);
        mouse.vR=v +omega*mouse.L/2;
        mouse.vL=v -omega*mouse.L/2;
        mouse.cell=curCell;
    
        % Mexendo o mouse de fato (e na animação)
        % --- CINEMÁTICA DIFERENCIAL ---
        v_media = (mouse.vR + mouse.vL) / 2;
        w_mouse = (mouse.vR - mouse.vL) / mouse.L;
        mouse.x = mouse.x + v_media * cos(mouse.theta) * dt;
        mouse.y = mouse.y + v_media * sin(mouse.theta) * dt;
        mouse.theta = mouse.theta + w_mouse * dt;
        mouse.theta = atan2(sin(mouse.theta), cos(mouse.theta));

        % tempos de frame e da precisão simulação
        pause(0.001);
        dt=dt+0.001;
    end

    % Final visualization
    visualize_maze_bitfield(maze_grid, goal, floodval);
    title(sprintf('Terminou em %f segundos!',toc));
end






