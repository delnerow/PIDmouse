function [pulsos_L, pulsos_R] = encoder_simulado(mouse)
    % wL_real, wR_real em rad/s
    % pulsos_por_volta: resolução do encoder (ex: 360)

    pulsos_L = (mouse.wL_real / (2*pi)) * mouse.pulsos_por_volta*0.001;
    pulsos_R = (mouse.wR_real / (2*pi)) * mouse.pulsos_por_volta*0.001;
end