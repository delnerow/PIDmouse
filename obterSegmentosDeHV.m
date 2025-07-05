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