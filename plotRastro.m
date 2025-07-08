function plotRastro(ax, posicoes)
    % Plota o rastro completo do robô durante sua navegação pelo labirinto,
    % mostrando o caminho percorrido desde o início até o final da simulação.
    % O rastro é visualizado como uma linha contínua com marcações especiais.
    %
    % PARÂMETROS DE ENTRADA:
    %   ax - Handle dos eixos onde o rastro será desenhado
    %   posicoes - Matriz Nx2 com posições (x,y) do robô ao longo do tempo:
    %              Cada linha representa uma posição [x, y] em um instante
    %              N = número total de posições registradas
    %
    % PARÂMETROS DE SAÍDA:
    %   Nenhum - Função apenas para visualização
    %

    % Plota o rastro do mouse pelo labirinto (apenas o centro)
    % ax: eixo onde plotar
    % posicoes: matriz [Nx2] com posições (x,y) do mouse
    % orientacoes: vetor [Nx1] com orientações (theta) do mouse
    % lado_mouse: tamanho do lado do mouse (não usado, mas mantido para compatibilidade)
    
    % Plotar linha do centro do rastro (caminho percorrido)
    plot(ax, posicoes(:, 1), posicoes(:, 2), 'b-', 'LineWidth', 2, 'Color', [0.2, 0.6, 1]);
    
    % Opcional: marcar pontos específicos (início, fim, etc.)
    if length(posicoes) > 0
        % Marcar posição inicial
        plot(ax, posicoes(1, 1), posicoes(1, 2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        % Marcar posição final
        plot(ax, posicoes(end, 1), posicoes(end, 2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    end
end 