function [xx,yy]=  path_to_points (path,ordens, cellSize,ax)
    % Converte um caminho discreto (sequência de células) em uma
    % trajetória de pontos contínuos representando os centros das
    % células. Esta função é uma versão simplificada de path_to_line
    % que não interpola entre pontos.
    %
    % PARÂMETROS DE ENTRADA:
    %   path - Matriz Mx2 com sequência de células visitadas [row, col]
    %   ordens - Vetor com comandos discretos (não usado nesta versão)
    %   cellSize - Tamanho de cada célula do labirinto em metros
    %   ax - Handle dos eixos onde a trajetória será plotada
    %
    % PARÂMETROS DE SAÍDA:
    %   xx - Vetor com coordenadas x dos pontos da trajetória
    %   yy - Vetor com coordenadas y dos pontos da trajetória
    %

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