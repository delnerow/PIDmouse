function F = funcaoCusto(planta,requisitos,parametros)
    % Calcula o custo de um conjunto de ganhos do controlador PI baseado
    % na diferença entre os requisitos de desempenho desejados e os
    % valores obtidos com a simulação da resposta ao degrau.
    %
    % PARÂMETROS DE ENTRADA:
    %   planta - Estrutura com parâmetros do motor DC:
    %            .J - Inércia total (kg·m²)
    %            .B - Atrito viscoso (Nm·s/rad)
    %            .kt - Constante de torque (Nm/A)
    %            .R - Resistência do enrolamento (Ω)
    %            .L - Indutância do enrolamento (H)
    %   requisitos - Estrutura com requisitos de desempenho:
    %                .tr - Tempo de subida desejado (segundos)
    %                .mp - Overshoot máximo desejado (adimensional, 0-1)
    %   parametros - Vetor com ganhos do controlador [Kp, Ki]
    %
    % PARÂMETROS DE SAÍDA:
    %   F - Valor da função de custo (erro quadrático)
    %       F = (tr_req - tr_obt)² + (mp_req - mp_obt)²
    %

    Kp = parametros(1);
    Ki = parametros(2);
    J = planta.J;
    b = planta.B;
    Kt = planta.kt;
    R = planta.R;
    L = planta.L;
    trReq = requisitos.tr;
    mpReq = requisitos.mp;
    s=tf('s');
    Gf=(Kp*Kt*s+Ki*Kt)/(J*L*s^3+(J*R+L*b)*s^2+(R*b+Kt^2+Kp*Kt)*s+Ki*Kt);
    S=stepinfo(Gf, 'RiseTimeLimits', [0 1]);
    mp=S.Overshoot/100;
    tr=S.RiseTime;
    F=(trReq-tr)^2+(mpReq-mp)^2;
end

