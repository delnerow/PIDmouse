function polys = gerarParedesPolyshape(paredes, espessura)
    if nargin < 2
        espessura = 0.05;
    end
    
    polys = [];

    % Paredes verticais
    for i = 1:size(paredes.V, 1)
        x = paredes.V(i, 1);
        y0 = paredes.V(i, 2);
        y1 = paredes.V(i, 3);
        poly = polyshape([x, x+espessura, x+espessura, x], ...
                         [y0, y0, y1, y1]);
        polys = [polys, poly];
    end

    % Paredes horizontais
    for i = 1:size(paredes.H, 1)
        y = paredes.H(i, 1);
        x0 = paredes.H(i, 2);
        x1 = paredes.H(i, 3);
        poly = polyshape([x0, x1, x1, x0], ...
                         [y, y, y+espessura, y+espessura]);
        polys = [polys, poly];
    end
end

