function dist = sensorLeitura(robo, paredes, lado)
    % lado = 'esquerda' ou 'direita'
    paredes=obterSegmentosDeHV(paredes);
    alcance = 1.0; % alcance máximo do sensor

    if strcmp(lado, 'direita')
        theta_s  = robo.theta_real - pi/2;
    elseif strcmp(lado, 'esquerda')
        theta_s  = robo.theta_real + pi/2;
    else
        theta_s  = robo.theta_real;
    end

    % Ponto inicial do raio
    x0 = robo.x_real;
    y0 = robo.y_real;

    x1 = x0 + alcance * cos(theta_s);
    y1 = y0 + alcance * sin(theta_s);

    min_dist = inf;

    for k = 1:size(paredes,1)
        [intersect, xi, yi] = segmentIntersect( ...
            x0, y0, x1, y1, ...
            paredes(k,1), paredes(k,2), paredes(k,3), paredes(k,4));
        
        if intersect
            d = sqrt((xi - x0)^2 + (yi - y0)^2);
            if d < min_dist
                min_dist = d;
            end
        end
    end

    if isfinite(min_dist)
        dist = min_dist;
    else
        dist = alcance;
    end
end



function [intersects, xi, yi] = segmentIntersect(x1,y1,x2,y2, x3,y3,x4,y4)
    % Vetores das retas
    dx1 = x2 - x1; dy1 = y2 - y1;
    dx2 = x4 - x3; dy2 = y4 - y3;

    denom = dx1 * dy2 - dy1 * dx2;

    if denom == 0
        intersects = false; xi = nan; yi = nan; return; % Paralelas
    end

    dx = x3 - x1; dy = y3 - y1;
    t = (dx * dy2 - dy * dx2) / denom;
    u = (dx * dy1 - dy * dx1) / denom;

    if t >= 0 && t <= 1 && u >= 0 && u <= 1
        xi = x1 + t * dx1;
        yi = y1 + t * dy1;
        intersects = true;
    else
        xi = nan; yi = nan;
        intersects = false;
    end
end
function segmentos = obterSegmentosDeHV(paredes)
    segmentos = [];

    % Horizontais
    for i = 1:size(paredes.H, 1)
        y = paredes.H(i, 1);
        x0 = paredes.H(i, 2);
        x1 = paredes.H(i, 3);
        segmentos(end+1, :) = [x0, y, x1, y];
    end

    % Verticais
    for i = 1:size(paredes.V, 1)
        x = paredes.V(i, 1);
        y0 = paredes.V(i, 2);
        y1 = paredes.V(i, 3);
        segmentos(end+1, :) = [x, y0, x, y1];
    end
end