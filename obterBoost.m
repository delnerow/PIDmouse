function boost= obterBoost(consec_trecho, cellPercorridas, tipo)
        % Boost com pico de velocidade no meio do trecho reto
        
        if strcmp(tipo, 'gauss') 
             n = consec_trecho;
            boost_max= n/2;
            mu = n/2;
            sigma = n/5; % quanto menor, mais estreito o pico
            boost = 1 + (boost_max - 1) * exp(-0.5 * ((cellPercorridas - mu)/sigma)^2);

        % Boost com pico de velocidade no início e decrescendo até o final
        elseif strcmp(tipo, 'rampa')
       
            boost = max(consec_trecho-cellPercorridas,1);

        % Sem boost
        else
            boost=1;
        end


end