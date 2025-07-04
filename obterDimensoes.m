function [start,goal,mouse]= obterDimensoes()
 % Célular de partida e célula objetivo
    start = [1,1];    % [row, col]
    goal = [8,8];   % [row, col]
    
    % Inicialização do robô
    % Constantes
    mouse = struct();
    mouse.wheel = 0.1;
    mouse.L = 16/18;                  % distância entre rodas (1:18 cm)
    mouse.side=0.5;                % Diametro das rodas
    

    mouse.v_base=1;               % velocidade padrão
    % Variáveis
    mouse.distancia_acumulada = 0;  % um odometro resetado a cada célular
    mouse.wL_real =0;
    mouse.wR_real=0;
    mouse.vL_real = 0;                   % velocidade da roda esquerda (m/s)
    mouse.vR_real = 0;                   % velocidade da roda direita (m/s)
    mouse.theta_real = -pi/2;           % orientação (rad)
    mouse.dir = 2;                  % 0=up, 1=right, 2=down, 3=left, pra onde ele precisa facear no momento (global)
    mouse.cell=start;               % celula da matriz q ele esta
    mouse.rot = 0;                  % 0=reto, 1=giraDireita, -1; giraEsquerda
    mouse.x_real = mouse.cell(2)-0.5;    % posição x
    mouse.y_real = 16-mouse.cell(1)+0.5; % posição y
    
    mouse.pulsos_por_volta = 360;
    mouse.encoder_L = 0;
        mouse.encoder_R = 0;
        mouse.encoder_L_prev = 0;
        mouse.encoder_R_prev = 0;
    mouse.wL_encoder =0;
    mouse.wR_encoder=0;
    mouse.vL_encoder = 0;                   % velocidade da roda esquerda (m/s)
    mouse.vR_encoder = 0;                   % velocidade da roda direita (m/s)
    mouse.x_encoder = mouse.cell(2)-0.5;    % posição x
    mouse.y_encoder = 16-mouse.cell(1)+0.5; % posição y
    mouse.theta_encoder= -pi/2;
end
