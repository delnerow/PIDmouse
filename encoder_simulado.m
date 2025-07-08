function [encoder_L,encoder_R,encoder_L_prev,encoder_R_prev, wL_encoder,wR_encoder] = encoder_simulado(mouse,dt)
    % Simula o comportamento de encoders reais, incluindo ruído, quantização
    % e filtragem. Os encoders fornecem feedback de velocidade para o sistema
    % de controle e odometria do robô.
    %
    % PARÂMETROS DE ENTRADA:
    %   mouse - Estrutura contendo estado atual do robô:
    %           .wL_real, .wR_real - Velocidades angulares reais das rodas (rad/s)
    %           .encoder_L, .encoder_R - Contadores atuais dos encoders
    %           .encoder_L_prev, .encoder_R_prev - Contadores anteriores
    %           .pulsos_por_volta - Resolução do encoder (pulsos por volta)
    %   dt - Intervalo de tempo da simulação (segundos)
    %
    % PARÂMETROS DE SAÍDA:
    %   encoder_L, encoder_R - Novos contadores dos encoders (pulsos acumulados)
    %   encoder_L_prev, encoder_R_prev - Contadores anteriores atualizados
    %   wL_encoder, wR_encoder - Velocidades angulares estimadas pelos encoders (rad/s)
    %


    % wL_real, wR_real em rad/s
    % pulsos_por_volta: resolução do encoder (ex: 360)

    % Velocidades reais das rodas
    wL_real = mouse.wL_real;
    wR_real = mouse.wR_real;
    
    % Simular ruído do encoder (mais realista)
    noise_factor = 0.02; % 2% de ruído
    wL_noisy = wL_real * (1 + noise_factor * (rand() - 0.5));
    wR_noisy = wR_real * (1 + noise_factor * (rand() - 0.5));
    
    % Calcular pulsos com ruído
    pulsos_L = (wL_noisy / (2*pi)) * mouse.pulsos_por_volta * dt;
    pulsos_R = (wR_noisy / (2*pi)) * mouse.pulsos_por_volta * dt;
    
    % Quantização dos pulsos (simular resolução finita)
    pulsos_L = round(pulsos_L);
    pulsos_R = round(pulsos_R);
    
    % [1] Acumula nos encoders simulados
    encoder_L = mouse.encoder_L + pulsos_L;
    encoder_R = mouse.encoder_R + pulsos_R;
    
    % [2] Estima a velocidade angular da roda com base nos pulsos contados no intervalo
    wL_encoder = ((encoder_L - mouse.encoder_L_prev) * 2*pi) / mouse.pulsos_por_volta / dt;
    wR_encoder = ((encoder_R - mouse.encoder_R_prev) * 2*pi) / mouse.pulsos_por_volta / dt;
    
    % Filtro de média móvel para suavizar as velocidades estimadas
    persistent wL_history wR_history
    if isempty(wL_history)
        wL_history = zeros(1, 5);
        wR_history = zeros(1, 5);
    end
    
    % Adicionar nova medição ao histórico
    wL_history = [wL_encoder, wL_history(1:end-1)];
    wR_history = [wR_encoder, wR_history(1:end-1)];
    
    % Aplicar filtro de média móvel
    wL_encoder = mean(wL_history);
    wR_encoder = mean(wR_history);
    
    % [3] Atualiza o valor anterior (para o próximo delta)
    encoder_L_prev = mouse.encoder_L;
    encoder_R_prev = mouse.encoder_R;
end