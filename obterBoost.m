function boost= obterBoost(consec_trecho, cellPercorridas, tipo, ordem)
    % Calcula o fator de boost de velocidade baseado no tipo de movimento
    % e na posição atual dentro de um trecho consecutivo. O boost é usado
    % para otimizar a velocidade em trechos retos e diagonais.
    %
    % PARÂMETROS DE ENTRADA:
    %   consec_trecho - Número total de células no trecho consecutivo
    %   cellPercorridas - Número de células já percorridas no trecho atual
    %   tipo - String indicando o tipo de boost:
    %          'gauss': Boost gaussiano (pico no meio do trecho)
    %          'rampa': Boost linear (decresce ao longo do trecho)
    %          'default': Sem boost (velocidade constante)
    %   ordem - Comando atual (-1, 0, 1) para ajuste do boost
    %
    % PARÂMETROS DE SAÍDA:
    %   boost - Fator multiplicativo da velocidade (>= 1)
    %           boost = 1: Velocidade normal
    %           boost > 1: Velocidade aumentada
    %
    % TIPOS DE BOOST:
    %   1. GAUSSIANO ('gauss'):
    %      - Pico de velocidade no meio do trecho
    %      - Decaimento suave nas extremidades
    %      - Parâmetros: mu = n/2, sigma = n/4
    %      - Fórmula: boost = 1 + (boost_max - 1) * exp(-0.5 * ((cellPercorridas - mu)/sigma)^2)
    %
    %   2. RAMPA ('rampa'):
    %      - Velocidade máxima no início do trecho
    %      - Decrescimento linear até o final
    %      - Fórmula: boost = max(consec_trecho - cellPercorridas, 1)
    %
    %   3. PADRÃO ('default'):
    %      - Sem boost, velocidade constante
    %      - boost = 1
    %
    % AJUSTES ESPECÍFICOS:
    %   - Para diagonais (ordem = ±1): Pico gaussiano reduzido pela metade
    %   - Boost máximo limitado para evitar velocidades excessivas


        % Boost com pico de velocidade no meio do trecho reto
        if strcmp(tipo, 'gauss')
            n = consec_trecho;
            meio = (n-cellPercorridas)/2;
            if abs(ordem)==1, meio = meio/2; end
           
            boost_max = max(meio,1); % Valor fixo máximo do boost
            mu = n/2; % Pico no meio do trecho
            sigma = n/4; % Largura do pico (quanto menor, mais estreito)
            boost = 1 + (boost_max - 1) * exp(-0.5 * ((cellPercorridas - mu)/sigma)^2);

        % Boost com pico de velocidade no início e decrescendo até o final
        elseif strcmp(tipo, 'rampa')
       
            boost = max(consec_trecho-cellPercorridas,1);

        % Sem boost
        else
            boost=1;
        end


end