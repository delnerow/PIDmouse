function [encoder_L,encoder_R,encoder_L_prev,encoder_R_prev, wL_encoder,wR_encoder] = encoder_simulado(mouse,dt)
    % wL_real, wR_real em rad/s
    % pulsos_por_volta: resolução do encoder (ex: 360)

    pulsos_L = (mouse.wL_real / (2*pi)) * mouse.pulsos_por_volta*0.001;
    pulsos_R = (mouse.wR_real / (2*pi)) * mouse.pulsos_por_volta*0.001;
    % [1] Acumula nos encoders simulados
    encoder_L = mouse.encoder_L + pulsos_L;
    encoder_R = mouse.encoder_R + pulsos_R;
    % [2] Estima a velocidade angular da roda com base nos pulsos contados no intervalo
    wL_encoder = ((mouse.encoder_L - mouse.encoder_L_prev) * 2*pi) / mouse.pulsos_por_volta / dt;
    wR_encoder = ((mouse.encoder_R - mouse.encoder_R_prev) * 2*pi) / mouse.pulsos_por_volta / dt;
    % [3] Atualiza o valor anterior (para o próximo delta)
    encoder_L_prev = mouse.encoder_L;
    encoder_R_prev = mouse.encoder_R;
end