function dists= obterInfravermelho(coord, paredes)
    % Simula a leitura de três sensores infravermelhos do robô micromouse
    % usando ray casting para detectar distâncias até as paredes do labirinto.
    % Os sensores são posicionados frontalmente e nas laterais do robô.
    %
    % PARÂMETROS DE ENTRADA:
    %   coord - Estrutura com posição e orientação do robô:
    %           .x - Posição x do robô no sistema de coordenadas do mundo
    %           .y - Posição y do robô no sistema de coordenadas do mundo
    %           .theta - Orientação do robô em radianos
    %   paredes - Matriz Mx4 com segmentos de linha das paredes:
    %             [x1, y1, x2, y2] - coordenadas inicial e final de cada segmento
    %
    % PARÂMETROS DE SAÍDA:
    %   dists - Estrutura contendo distâncias medidas pelos sensores:
    %           .dist_f - Distância medida pelo sensor frontal (metros)
    %           .dist_esq - Distância medida pelo sensor esquerdo (metros)
    %           .dist_dir - Distância medida pelo sensor direito (metros)
    %
    % Obtém leitura dos 3 sensores infravermlehos
        dists.dist_esq = sensorLeitura(coord, paredes, 'esquerda');
        dists.dist_dir = sensorLeitura(coord, paredes, 'direita');
        dists.dist_f=sensorLeitura(coord, paredes, 'frente');
end
