function [dist_esq,dist_dir,dist_f]= obterInfravermelho(coord, paredes)
        % Obtém leitura dos 3 sensores infravermlehos
        dist_esq = sensorLeitura(coord, paredes, 'esquerda');
        dist_dir = sensorLeitura(coord, paredes, 'direita');
        dist_f=sensorLeitura(coord, paredes, 'frente');
end
