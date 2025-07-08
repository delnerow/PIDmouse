function consecutivos = obterSequenciaOrdens(ordens)
    % Analisa uma sequência de comandos discretos para identificar
    % trechos consecutivos que formam movimentos contínuos. Esta função
    % é usada para otimização de velocidade em trechos retos e diagonais.
    %
    % PARÂMETROS DE ENTRADA:
    %   ordens - Vetor com comandos discretos: -1 (esquerda), 0 (frente), 1 (direita)
    %
    % PARÂMETROS DE SAÍDA:
    %   consecutivos - Vetor com índices que marcam o fim de cada trecho consecutivo
    %                  Cada índice indica onde termina um trecho de comandos similares
    %                  Exemplo: [3, 4] significa trechos de 1-3 e 4-4
    %

    % Cada indice representa quando para um trecho de consecutivos
    % Ex, (3,4...) signifique que tem do 1 ao 3 em ordens, e do 4 ao 4
    % 0 0 0 0 é uma sequencia de consecutivos, gera uma linha reta. 1 -1 1 -1
    % também, pois é uma diagonal
    i = 1;
    consecutivos = [];
    while i <= length(ordens)
        best=i;
        if(i==length(ordens))
            consecutivos(end+1)=best;
        elseif(ordens(i+1)== ordens(i)*(-1))
            best= best+1; 
        else
            consecutivos(end+1)=best;
            best=i+1;
        end
        i=i+1;

    end

end
