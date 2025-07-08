function p = mousePolyshape(coord, L)
    % Cria um polyshape representando a geometria do robô na posição
    % e orientação atuais. O polyshape é usado para detecção precisa
    % de colisões com as paredes do labirinto.
    %
    % PARÂMETROS DE ENTRADA:
    %   coord - Estrutura com posição e orientação do robô:
    %           .x - Posição x do robô no sistema de coordenadas do mundo
    %           .y - Posição y do robô no sistema de coordenadas do mundo
    %           .theta - Orientação do robô em radianos
    %   L - Largura/diâmetro do robô em metros
    %
    % PARÂMETROS DE SAÍDA:
    %   p - Polyshape representando a geometria do robô:
    %       Forma retangular com dimensões L x L
    %       Centrado na posição (x, y) do robô
    %       Rotacionado pelo ângulo theta
    %

    % Polyshape ( para detectar colisão com paredes )
    x=coord.x;
    y=coord.y;
    theta=coord.theta;
    % Centro no (x, y), ângulo theta (rad), dimensões L (largura)
    % Define os 4 vértices no sistema local do mouse (centrado)
    verts = [-L/2, -L/2;
              L/2, -L/2;
              L/2,  L/2;
             -L/2,  L/2];

    % Matriz de rotação
    R = [cos(theta), -sin(theta);
         sin(theta),  cos(theta)];

    % Aplica rotação e translada para (x, y)
    verts = (R * verts')';
    verts(:,1) = verts(:,1) + x;
    verts(:,2) = verts(:,2) + y;

    % Cria o polyshape
    p = polyshape(verts);
end
