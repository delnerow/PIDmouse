function micromouse(maze)
    % Maze no formato bitfield.
    % Wall bits: 0x08=West, 0x01=South, 0x02=East, 0x04=North
    
    maze_grid=load_maze_bin("mazes/"+maze+".maz");

    % NxN, dimensão do labirinto
    N=size(maze_grid,1);
    [start,goal,mouse]=obterDimensoes();
    
    % Obter paredes pelo binario, ela os sensores detectam
    paredes = obterParedes(maze_grid);

    % Paredes como segmentos
    paredesHV =obterSegmentosDeHV(paredes);

    % Polyshape específica pra detectar colisão com mouse
    wall_polys = gerarParedesPolyshape(paredes);

    % Fazendo floofill no mapa inteiro
    floodval = flood_fill_micromouse(maze_grid, goal, 0, start);
    
    % Plotando o mapa
    ax = gca;
    visualize_maze_bitfield(wall_polys,N ,goal, floodval,ax);

    % Melhor caminho até o goal, com celulas e comandos/direcoes delas
    [path,ordens] = stack_caminho(floodval,maze_grid,start);
    % Stack de celulas vira curva
    [xx, yy] = path_to_line(path,ordens, 1,ax);

    % Plotando mouse pela primeira vez
    % Polyshape do mouse, para  detectar colisão com parede
    coord.x=mouse.x_real; coord.y=mouse.y_real; coord.theta=mouse.theta_real;
    poly_mouse = mousePolyshape(coord, mouse.side);
    draw_mouse = plot(ax,poly_mouse, 'FaceColor', 'blue', 'FaceAlpha', 0.4); 
    % Plotar raios do sensor
    raios = plotaSensores(ax, mouse.x_real, mouse.y_real);

    % Inicializa controladores
    ctrl = PIDlookahead();
    giro = PIDgiro();
    
    % Vetor que da boost ao robo quando ve varios comando de linha reta
    consecutivos = obterSequenciaOrdens(ordens); 
    trecho=1;           % Em qual trecho de consecutivos esta
    cellPercorridas=0;  % quantas celulas do trecho total (curva) percorreu

    % colidiu ou não
    % colidiu = false;

    % Main Loop
    dt=0.01;
    t=0; %para ver frames e tempo da simuação
    tic; 
    while ~isequal(mouse.cell, goal)
        % As coordenadas reais do mouse
        coord.x=mouse.x_real;
        coord.y=mouse.y_real;
        coord.theta=mouse.theta_real;

        % Boost de velocidade atual
        boost = max(consecutivos(trecho)-cellPercorridas,1);

        % Obtendo leitura dos sensores
        [dist_esq,dist_dir,dist_f]= obterInfravermelho(coord, paredesHV);

        % Chamando o PID
        [vR,vL, ctrl] = ctrl.update(mouse, xx, yy, dt, dist_esq,dist_dir,dist_f, boost,ax);
        
        % Encoder
        [mouse.encoder_L,mouse.encoder_R,mouse.encoder_L_prev,mouse.encoder_R_prev, mouse.wL_encoder,mouse.wR_encoder] = encoder_simulado(mouse,dt);
      
        % Obtendo velocidades angulares das rodas
        [mouse.wL_real, mouse.wR_real, giro]= giro.update(mouse, vR,vL,dt);
        
        % atualizando o Mickey
        mouse.vR_real=mouse.wR_real*mouse.wheel;
        mouse.vL_real=mouse.wL_real*mouse.wheel;

        mouse.vR_encoder=mouse.wR_encoder*mouse.wheel;
        mouse.vL_encoder=mouse.wL_encoder*mouse.wheel;
        % Mexendo o mouse
        % --- CINEMÁTICA DIFERENCIAL REAL ---
        v_media = (mouse.vR_real + mouse.vL_real) / 2;
        w_mouse = (mouse.vR_real - mouse.vL_real) / mouse.L;
        mouse.x_real = mouse.x_real + v_media * cos(mouse.theta_real) * dt;
        mouse.y_real = mouse.y_real + v_media * sin(mouse.theta_real) * dt;
        mouse.theta_real = mouse.theta_real + w_mouse * dt;
        mouse.theta_real = atan2(sin(mouse.theta_real), cos(mouse.theta_real));
        
        % --- CINEMÁTICA DIFERENCIAL ENCODER (ODOMETRIA) ---
        v_media_encoder = (mouse.vR_encoder + mouse.vL_encoder) / 2;
        w_mouse_encoder = (mouse.vR_encoder - mouse.vL_encoder) / mouse.L;
        
        % Usar Runge-Kutta de 4ª ordem para integração mais precisa
        k1_x = v_media_encoder * cos(mouse.theta_encoder);
        k1_y = v_media_encoder * sin(mouse.theta_encoder);
        k1_theta = w_mouse_encoder;
        
        k2_x = v_media_encoder * cos(mouse.theta_encoder + k1_theta * dt/2);
        k2_y = v_media_encoder * sin(mouse.theta_encoder + k1_theta * dt/2);
        k2_theta = w_mouse_encoder;
        
        k3_x = v_media_encoder * cos(mouse.theta_encoder + k2_theta * dt/2);
        k3_y = v_media_encoder * sin(mouse.theta_encoder + k2_theta * dt/2);
        k3_theta = w_mouse_encoder;
        
        k4_x = v_media_encoder * cos(mouse.theta_encoder + k3_theta * dt);
        k4_y = v_media_encoder * sin(mouse.theta_encoder + k3_theta * dt);
        k4_theta = w_mouse_encoder;
        
        % Atualizar posição e orientação usando apenas odometria
        mouse.x_encoder = mouse.x_encoder + (k1_x + 2*k2_x + 2*k3_x + k4_x) * dt / 6;
        mouse.y_encoder = mouse.y_encoder + (k1_y + 2*k2_y + 2*k3_y + k4_y) * dt / 6;
        mouse.theta_encoder = mouse.theta_encoder + (k1_theta + 2*k2_theta + 2*k3_theta + k4_theta) * dt / 6;
        mouse.theta_encoder = atan2(sin(mouse.theta_encoder), cos(mouse.theta_encoder));
        mouse.x_encoder=mouse.x_real;
        mouse.y_encoder=mouse.y_real;
        mouse.theta_encoder=mouse.theta_real;
        curCell = returnCell(N,mouse);
        if ~isequal(curCell,mouse.cell), cellPercorridas=cellPercorridas+1;end
        if(cellPercorridas == consecutivos(trecho)), trecho = trecho+1;end
        mouse.cell=curCell;

        % tempos de frame
        t=t+1;
        if mod(t, 1) == 0
            % Visualize mouse
            poly_mouse = mousePolyshape(coord, mouse.side);
            draw_mouse=visualize_mouse(ax,poly_mouse,draw_mouse);
            % Reta do sensor 
            visualize_ray(coord,paredesHV,raios);
            % Debug
            fprintf("(x) e (y) e(theta) :%f,%f  %f \n",mouse.x_real,mouse.y_real,mouse.theta_real/pi*180);
            %fprintf("ENCODER: (x) e (y) e(theta) :%f,%f  %f \n",mouse.x_encoder,mouse.y_encoder,mouse.theta_encoder/pi*180);
            %fprintf("Trecho, percorridas, boost : %.3f , %.1f, %f\n", trecho,cellPercorridas, boost);
            %fprintf("ENCODER: (v) e (omega) :%f,%f  \n",(mouse.vR_encoder  + mouse.vL_encoder ) / 2, (mouse.vR_encoder  - mouse.vL_encoder ) / mouse.L);
            fprintf("Real: (v) e (omega) :%f,%f  \n",(mouse.vR_real  + mouse.vL_real ) / 2, (mouse.vR_real  - mouse.vL_real ) / mouse.L);
            fprintf("Giros comandados: \n R: %f \n L: %f \n",mouse.wR_real,mouse.wL_real);
            fprintf("Velocidades comandadas: \n v: %f \n w: %f \n",(vR + vL) / 2,(vR-vL)/(2*mouse.L));
        end
        
        if mod(t, 1/dt) == 0
            %clc;
            fprintf("Tempo %.2f \n", t);
           
        end

        %for i = 1:length(wall_polys)
        %    if overlaps(poly_mouse, wall_polys(i))
        %        colidiu = true;
        %        break;
        %    end
        %end
        
        %if colidiu
        %    disp("🟥 Colisão detectada! Encerrando simulação...");
        %return; 
        %end
    end

    % Final
    title(sprintf('Terminou em %f segundos!',toc));
end






