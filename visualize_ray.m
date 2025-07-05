function visualize_ray(coord,paredes,raios)
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
