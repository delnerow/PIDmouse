function segmentos = obterSegmentosDeHV(paredes)
    % Converte a representação de paredes (horizontais e verticais) em
    % uma lista unificada de segmentos de linha para uso em algoritmos
    % de detecção de colisão e ray casting.
    %
    % PARÂMETROS DE ENTRADA:
    %   paredes - Estrutura contendo paredes extraídas do labirinto:
    %             .V - Matriz de paredes verticais [x; y1; y2]
    %                  Cada coluna representa uma parede vertical
    %             .H - Matriz de paredes horizontais [y; x1; x2]
    %                  Cada coluna representa uma parede horizontal
    %
    % PARÂMETROS DE SAÍDA:
    %   segmentos - Matriz Mx4 onde cada linha representa um segmento de linha:
    %               [x1, y1, x2, y2] - coordenadas inicial e final do segmento
    %               M = número total de segmentos (horizontais + verticais)
    %

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