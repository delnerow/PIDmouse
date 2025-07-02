
function  comandos = mef(curCell, mouse, floodval, maze_grid,paredes)

    % Debug
    % fprintf("(x) e (y) e(theta) :%f,%f  %f \n",mouse.x,mouse.y,mouse.theta/pi*180);
    coord=['N','E','S','W'];
    fprintf("Mouse esta na celula [%f,%f]  querendo ir para %s \n",curCell(1),curCell(2), coord(mouse.dir+1));
    % fprintf("mas na sua cabecinha ele esta em [%f,%f]\n ",mouse.cell(1),mouse.cell(2));
    
    % Se entrar em nova célula ou for a primeira
    if ~isequal(curCell,mouse.cell) | isequal(mouse.cell,[1,1])
       next_dir = get_smallest_neighbor_dir(floodval, maze_grid, curCell, mouse.dir)-1;  % 0=up, 1=right, 2=down, 3=left
       delta_dir = next_dir-mouse.dir;            % 0=reto, 1=giraDireita, -1; giraEsquerda
       if abs(delta_dir) == 3, delta_dir= delta_dir/(-3); end
       fprintf("Vamos ter que fazer %f \n", delta_dir);
       
       %Define novos comandos para o mouse local, que ainda não retornou
       mouse.cell=curCell;
       mouse.rot=delta_dir;
       mouse.dir=next_dir;
       mouse.distancia_acumulada=0;
       % Debug
       fprintf("!!!!!!!!Mudando!!!!!!\n")
       coord=['N','E','S','W'];
       fprintf("%s",coord(next_dir+1));
    end
       % Define novos/mesmos comandos para o mouse, quando função retornar
       comandos.cell=curCell;
       comandos.rot=mouse.rot;
       comandos.dir=mouse.dir;
       comandos.ac=mouse.distancia_acumulada;

    if mouse.rot == 0
       fprintf("Reto\n")
       comandos.velocidades = vaiFrente(mouse,paredes);
    elseif mouse.rot == 1
       fprintf("gira direita\n")
       comandos.velocidades = giraDireita(mouse,paredes); 
    elseif mouse.rot == -1
       fprintf("gira esquerda\n")
       comandos.velocidades = giraEsquerda(mouse,paredes) ;
    end
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


% pid sem ser no simulink pq estava travando louco
function [correcao, estado] = pid_simples(erro, estado, dt, Kp, Ki, Kd)
    estado.integral = estado.integral + erro * dt;
    derivada = (erro - estado.erro_anterior) / dt;
    correcao = Kp * erro + Ki * estado.integral + Kd * derivada;
    estado.erro_anterior = erro;
end


function velocidades = vaiFrente(mouse,paredes)
    
    % Simula sensores laterais (sem uso)
    dist_esq = sensorLeitura(mouse, paredes, 'esquerda');
    dist_dir = sensorLeitura(mouse, paredes, 'direita');
    
    persistent distancePID
    if isempty(distancePID)
        distancePID.integral = 0;
        distancePID.erro_anterior = 0;
    end
    persistent anglePID
    if isempty(anglePID)
        anglePID.integral = 0;
        anglePID.erro_anterior = 0;
    end
    dirCor=[pi/2,0,3*pi/2,pi];
    if abs(mouse.theta-dirCor(mouse.dir+1)) < 2*pi-abs(mouse.theta-dirCor(mouse.dir+1))
        erro_angle= mouse.theta-dirCor(mouse.dir+1);
    else
        if mouse.theta>dirCor(mouse.dir+1)
           erro_angle= -(2*pi-abs(mouse.theta-dirCor(mouse.dir+1)));
        else
            erro_angle= (2*pi-abs(mouse.theta-dirCor(mouse.dir+1)));
        end
    end

    Kp = 0.5; Ki = 0; Kd = 0;
    dt = 0.001;  %  passo de simulação
    mouse.distancia_acumulada = mouse.distancia_acumulada + (mouse.vR + mouse.vL) / 2 * dt;
    [correcao, distancePID] = pid_simples(1 - mouse.distancia_acumulada, distancePID, dt, Kp, Ki, Kd);

    Kp = 0.1; Ki = 0; Kd = 0;
    [gira, anglePID] = pid_simples(erro_angle, anglePID, dt, Kp, Ki, Kd);
    velocidades.L = correcao + gira;          
    velocidades.R = correcao - gira;

    % fprintf("Velocidades comandadas: \n Left: %f \n Right: %f \n",mouse.vL,mouse.vR);
    end

function velocidades=giraDireita(mouse,paredes)
    % faz 1/4 de circunferencia, literally
    w= mouse.v_base*2;
    velocidades.L = w*(0.5+mouse.L/2); 
    velocidades.R = w*(0.5-mouse.L/2);
end

function velocidades=giraEsquerda(mouse,paredes)
    % faz 1/4 de circunferencia, literally
    w= mouse.v_base*2;
    velocidades.L = w*(0.5-mouse.L/2); 
    velocidades.R = w*(0.5+mouse.L/2);
end








