% Micromouse Maze Simulation with Flood Fill Integration
% Uses bitfield maze encoding, flood fill logic, and dynamic wall checking.
function micro()
    clf; 
    % Maze in bitfield format (1D, row-major order, uint8).
    % Wall bits: 0x08=West, 0x01=South, 0x02=East, 0x04=North
    
    maze_grid=load_maze_bin("mazes/diag2.maz");

    N=size(maze_grid,1);
    [start,goal,mouse]=obterDimensoes();
    
    % Obter paredes do binario, plotada e nela os sensores detectam
    paredes = obterParedes(maze_grid);

    % Polyshape específica pra detectar colisão com mouse
    wall_polys = gerarParedesPolyshape(paredes);

    % figura da animação
    figure('Position', [820, 0, 700, 700]); % [left, bottom, width, height];
    ax = gca;
    hold on;

    % bizurando o floofill e contagem de passos do maze_grid
    floodval = flood_fill_micromouse(maze_grid, goal, 0, start);
    
    % plotando o mapa
    visualize_maze_bitfield(wall_polys,N ,goal, floodval,ax);

    % Melhor caminho até o goal, com celulas e comandos/direcoes delas
    [path,ordens] = stack_caminho(floodval,maze_grid,start);

    % Plotando mouse pela primeira vez

    % Polyshape do mouse, para  detectar colisão com parede
    poly_mouse = mousePolyshape(mouse.x, mouse.y, mouse.theta, mouse.side);
    h_mouse = plot(ax,poly_mouse, 'FaceColor', 'blue', 'FaceAlpha', 0.4); 
    % Plotar raio do sensor
    h_ray_f = plot(ax,[mouse.x mouse.x], [mouse.y mouse.y], 'r--'); % frente
    h_ray_d = plot(ax,[mouse.x mouse.x], [mouse.y mouse.y], 'b--'); % direita
    h_ray_e = plot(ax,[mouse.x mouse.x], [mouse.y mouse.y], 'g--'); % esquerda
    

    % Main Loop
    dt=0; %tempo inicial
    tic; 

    % Inicializa controlador híbrido
    ctrl = PIDlookahead();
    
    % Vetor que da boost ao robo quando ve varios comando de linha reta
    consecutivos = obterSequenciaOrdens(ordens);
    % Em qual trecho de consecutivos esta
    trecho=1;
    % quantas celulas do trecho total (curva) percorreu
    cellPercorridas=0;

    % Stack de celulas vira curva
    [xx, yy] = path_to_line(path,ordens, 1,ax);

    % colidiu ou não
    colidiu = false;
    

    while ~isequal(mouse.cell, goal)
        
        % Visualize mouse
        poly_mouse = mousePolyshape(mouse.x, mouse.y, mouse.theta, mouse.side);
        h_mouse=visualize_mouse(poly_mouse,mouse,h_mouse);
        % Reta do sensor 
        visualize_ray(mouse,paredes,h_ray_f,h_ray_d,h_ray_e);


        

        % O boost tem seu pico no meio do trecho, acelerando e desacelerando
        if(trecho==1), anterior=consecutivos(trecho);
        else, anterior = consecutivos(trecho-1);
        end 
        boost =abs((consecutivos(trecho)+anterior)/2-cellPercorridas);

        % Debug
        fprintf("(x) e (y) e(theta) :%f,%f  %f \n",mouse.x,mouse.y,mouse.theta/pi*180);
        fprintf("Trecho, percorridas, boost : %.3f , %.1f, %f\n", trecho,cellPercorridas, boost);

        % Chamando o PID
        dist_esq = sensorLeitura(mouse, paredes, 'esquerda');
        dist_dir = sensorLeitura(mouse, paredes, 'direita');
        dist_f=sensorLeitura(mouse, paredes, 'frente');
        [v, omega, ctrl] = ctrl.update(mouse, xx, yy, 0.001, dist_esq,dist_dir,dist_f, boost);

        % atualizando o Mickey
        mouse.vR=v +omega*mouse.L/2;
        mouse.vL=v -omega*mouse.L/2;
        curCell = returnCell(N,mouse);
        if ~isequal(curCell,mouse.cell), cellPercorridas=cellPercorridas+1;end
        if(cellPercorridas == consecutivos(trecho)), trecho = trecho+1;end
        mouse.cell=curCell;
        
        % Mexendo o mouse na animação
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

        for i = 1:length(wall_polys)
            if overlaps(poly_mouse, wall_polys(i))
                colidiu = true;
                break;
            end
        end
        
        if colidiu
            disp("🟥 Colisão detectada! Encerrando simulação...");
        return; 
        end
    end

    % Final visualization
    
    title(sprintf('Terminou em %f segundos!',toc));
end






