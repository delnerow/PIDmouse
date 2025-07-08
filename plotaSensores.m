function raios = plotaSensores(ax, x, y)
    % Cria os objetos gráficos iniciais para visualizar os raios dos
    % sensores infravermelhos. Esta função é chamada uma única vez
    % no início da simulação para configurar a visualização dos sensores.
    %
    % PARÂMETROS DE ENTRADA:
    %   ax - Handle dos eixos onde os raios serão desenhados
    %   x - Posição x inicial do robô no sistema de coordenadas do mundo
    %   y - Posição y inicial do robô no sistema de coordenadas do mundo
    %
    % PARÂMETROS DE SAÍDA:
    %   raios - Estrutura contendo handles dos objetos gráficos dos raios:
    %           .F - Handle do raio frontal (linha vermelha tracejada)
    %           .R - Handle do raio direito (linha azul tracejada)
    %           .L - Handle do raio esquerdo (linha verde tracejada)
    %

    % Plota pela primeira vez a linha de visada dos sensores
    raios.F = plot(ax,[x x], [y y], 'r--'); % frente
    raios.R = plot(ax,[x x], [y y], 'b--'); % direita
    raios.L = plot(ax,[x x], [y y], 'g--'); % esquerda
end
