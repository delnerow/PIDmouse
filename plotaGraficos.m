function plotaGraficos (time_vec,vel_ref,vel_real,lookds,boosts,w_ref,w_real,giroL_ref,giroL_real)
    % Gera um conjunto completo de gráficos para análise de desempenho
    % do sistema de controle do robô micromouse. Os gráficos mostram
    % a evolução temporal de diferentes variáveis de controle e estado.
    %
    % PARÂMETROS DE ENTRADA:
    %   time_vec - Vetor com instantes de tempo da simulação (segundos)
    %   vel_ref - Vetor com velocidades de referência (m/s)
    %   vel_real - Vetor com velocidades reais do robô (m/s)
    %   lookds - Vetor com valores de lookahead ao longo do tempo
    %   boosts - Vetor com valores de boost de velocidade ao longo do tempo
    %   w_ref - Vetor com velocidades angulares de referência (rad/s)
    %   w_real - Vetor com velocidades angulares reais (rad/s)
    %   giroL_ref - Vetor com velocidades de referência da roda esquerda (rad/s)
    %   giroL_real - Vetor com velocidades reais da roda esquerda (rad/s)
    %
    % PARÂMETROS DE SAÍDA:
    %   Nenhum - Função apenas para geração de gráficos
    %

    
            %  Velocidades - referencia e real
            figure;
            plot(time_vec, vel_ref, 'b-', 'DisplayName', 'Velocidade refenrencia');
            hold on;
            plot(time_vec, vel_real, 'r-', 'DisplayName', 'Velocidade real');
            xlabel('Tempo (s)');
            ylabel('Velocidade (x18cm/s)');
            legend;
            title('Velocidades Referencia vs Real no tempo');
            
            hold off;
    
            % Boosts e lookahead 
            figure;
            plot(time_vec, lookds, 'b-', 'DisplayName', 'Lookahead');
            hold on;
            plot(time_vec, boosts, 'r-', 'DisplayName', 'Boosts');
            xlabel('Time (s)');
            ylabel('Valor');
            legend;
            title('Lookahead vs Boosts no tempo');
            
            hold off;
    
            % Omega 
            figure;
            plot(time_vec, w_ref, 'b-', 'DisplayName', 'Omega referencia');
            hold on;
            plot(time_vec, w_real, 'r-', 'DisplayName', 'Omega real');
            xlabel('Time (s)');
            ylabel('Valor');
            legend;
            title('Omega referencia vs real no tempo');
            hold off;
    
            % Giro de uma roda 
            figure;
            plot(time_vec, giroL_ref, 'b-', 'DisplayName', 'Giro referencia');
            hold on;
            plot(time_vec, giroL_real, 'r-', 'DisplayName', 'Giro real');
            xlabel('Time (s)');
            ylabel('Valor');
            legend;
            title('Giro referencia vs real roda esquerda no tempo');
            
            hold off;
        
end