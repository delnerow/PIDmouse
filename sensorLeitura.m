function dist = sensorLeitura(coord, paredesHV, lado)
    % Lê de um sensor infravermelho específico
    % lado = 'esquerda','direita' ou 'frente
    
    alcance = 1.0; % alcance máximo do sensor
    % Ponto inicial do raio
    x0 = coord.x;
    y0 = coord.y;
    min_dist = inf;

    if     strcmp(lado, 'direita'),  theta_s  = coord.theta - pi/2;
    elseif strcmp(lado, 'esquerda'), theta_s  = coord.theta + pi/2;
    else,                            theta_s  = coord.theta;
    end

    x1 = x0 + alcance * cos(theta_s);
    y1 = y0 + alcance * sin(theta_s);

    for k = 1:size(paredesHV,1)
        [intersect, xi, yi] = segmentIntersect( ...
            x0, y0, x1, y1, ...
            paredesHV(k,1), paredesHV(k,2), paredesHV(k,3), paredesHV(k,4));
        
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
