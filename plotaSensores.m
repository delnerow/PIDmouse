function raios = plotaSensores(ax, x, y)
    % Plota pela primeira vez a linha de visada dos sensores
    raios.F = plot(ax,[x x], [y y], 'r--'); % frente
    raios.R = plot(ax,[x x], [y y], 'b--'); % direita
    raios.L = plot(ax,[x x], [y y], 'g--'); % esquerda
end
