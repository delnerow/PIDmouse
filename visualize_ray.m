function visualize_ray(mouse,paredes,h_ray_f,h_ray_d,h_ray_e)
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
end
