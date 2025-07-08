function polys = gerarParedesPolyshape(paredes, espessura)
    % Converte as paredes do labirinto (segmentos de linha) em polyshapes
    % com espessura para detecção precisa de colisões. Cada parede é
    % representada como um retângulo fino com dimensões apropriadas.
    %
    % PARÂMETROS DE ENTRADA:
    %   paredes - Estrutura contendo paredes extraídas do labirinto:
    %             .V - Matriz de paredes verticais [x; y1; y2]
    %                  Cada coluna representa uma parede vertical
    %             .H - Matriz de paredes horizontais [y; x1; x2]
    %                  Cada coluna representa uma parede horizontal
    %   espessura - Espessura das paredes em metros (padrão: 0.05)
    %
    % PARÂMETROS DE SAÍDA:
    %   polys - Array de polyshapes representando todas as paredes:
    %           Cada elemento é um retângulo fino representando uma parede
    %           Número total = número de paredes verticais + horizontais
    %


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

