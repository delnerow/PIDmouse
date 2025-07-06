function boost= obterBoost(consec_trecho, cellPercorridas, tipo)
        % Boost com pico de velocidade no meio do trecho reto
        
        if strcmp(tipo, 'gauss') 
            n = consec_trecho;
            boost_max = max((n-cellPercorridas)/2,1); % Valor fixo máximo do boost
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