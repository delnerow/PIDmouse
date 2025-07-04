function [start,goal,mouse]= obterDimensoes()
 % Célular de partida e célula objetivo
    start = [1,1];    % [row, col]
    goal = [8,8];   % [row, col]
    
    % Inicialização do robô
    % Constantes
    mouse = struct();
    mouse.wheel = 0.1;
    mouse.L = 16/18;                  % distância entre rodas (1:18 cm)
    mouse.side=0.5;
    mouse.R = 8/18;                 % Diametro das rodas
    pulsos_por_volta = 360;
    circunf = 2*pi*mouse.R;
    
    % Pulsos lidos em cada roda
    delta_pulsos_R = 10;
    delta_pulsos_L = 10;

    mouse.v_base=0.5;               % velocidade padrão
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
end
