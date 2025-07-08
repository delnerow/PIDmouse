function visualize_ray(coord,paredes,raios)
    % Atualiza a visualização dos raios dos sensores infravermelhos
    % em tempo real, mostrando o alcance e direção de cada sensor
    % do robô. Os raios são desenhados como linhas que vão do robô
    % até o ponto de interseção com as paredes.
    %
    % PARÂMETROS DE ENTRADA:
    %   coord - Estrutura com posição e orientação do robô:
    %           .x - Posição x do robô no sistema de coordenadas do mundo
    %           .y - Posição y do robô no sistema de coordenadas do mundo
    %           .theta - Orientação do robô em radianos
    %   paredes - Matriz Mx4 com segmentos de linha das paredes:
    %             [x1, y1, x2, y2] - coordenadas inicial e final de cada segmento
    %   raios - Estrutura com handles dos objetos gráficos dos raios:
    %           .F - Handle do raio frontal
    %           .R - Handle do raio direito
    %           .L - Handle do raio esquerdo
    %
    % PARÂMETROS DE SAÍDA:
    %   Nenhum - Função apenas para atualização visual
    %


    %Visualizar o alcande dos sensores infravermelhos
        x=coord.x;
        y=coord.y;
        theta=coord.theta;
        
        % Sensor frente
        dist_f = sensorLeitura(coord, paredes, 'frente');
        xf = x + dist_f * cos(theta);
        yf = y + dist_f * sin(theta);
        set(raios.F, 'XData', [x xf], 'YData', [y yf]);
        
        % Sensor direita
        dist_d = sensorLeitura(coord, paredes, 'direita');
        xd = x + dist_d * cos(theta- pi/2);
        yd = y + dist_d * sin(theta - pi/2);
        set(raios.R, 'XData', [x xd], 'YData', [y yd]);
        
        % Sensor esquerda
        dist_e = sensorLeitura(coord, paredes, 'esquerda');
        xe = x + dist_e * cos(theta + pi/2);
        ye = y + dist_e * sin(theta + pi/2);
        set(raios.L, 'XData', [x xe], 'YData', [y ye]);
end
