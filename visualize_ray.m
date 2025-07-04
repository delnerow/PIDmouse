function visualize_ray(mouse,paredes,h_ray_f,h_ray_d,h_ray_e)
% Sensor frente
        dist_f = sensorLeitura(mouse, paredes, 'frente');
        xf = mouse.x_real + dist_f * cos(mouse.theta_real);
        yf = mouse.y_real + dist_f * sin(mouse.theta_real);
        set(h_ray_f, 'XData', [mouse.x_real xf], 'YData', [mouse.y_real yf]);
        
        % Sensor direita
        dist_d = sensorLeitura(mouse, paredes, 'direita');
        xd = mouse.x_real + dist_d * cos(mouse.theta_real - pi/2);
        yd = mouse.y_real + dist_d * sin(mouse.theta_real - pi/2);
        set(h_ray_d, 'XData', [mouse.x_real xd], 'YData', [mouse.y_real yd]);
        
        % Sensor esquerda
        dist_e = sensorLeitura(mouse, paredes, 'esquerda');
        xe = mouse.x_real + dist_e * cos(mouse.theta_real + pi/2);
        ye = mouse.y_real + dist_e * sin(mouse.theta_real + pi/2);
        set(h_ray_e, 'XData', [mouse.x_real xe], 'YData', [mouse.y_real ye]);
end
