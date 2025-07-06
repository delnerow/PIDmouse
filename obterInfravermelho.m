function dists= obterInfravermelho(coord, paredes)
        % Obtém leitura dos 3 sensores infravermlehos
        dists.dist_esq = sensorLeitura(coord, paredes, 'esquerda');
        dists.dist_dir = sensorLeitura(coord, paredes, 'direita');
        dists.dist_f=sensorLeitura(coord, paredes, 'frente');
end
