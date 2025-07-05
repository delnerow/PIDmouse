function [xx,yy]=  path_to_points (path,ordens, cellSize,ax)
% Gera trajetória simples com centros das células do caminho

    % Converter células para coordenadas do mundo (centros das células)
    xx = [];
    yy = [];
    
    for i = 1:size(path,1)
        % Centro da célula [linha, coluna] → [x, y]
        x = (path(i,2) - 0.5) * cellSize;
        y = (16-path(i,1) + 0.5) * cellSize;
        xx = [xx x];
        yy = [yy y];
    end

    % Plot da trajetória
    plot(ax, xx, yy, 'b-', 'LineWidth', 2);
    plot(ax, xx, yy, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % Pontos nos centros
end