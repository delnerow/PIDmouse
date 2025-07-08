function ld = obterLookahead(v_base,v,w,tipo)
    % Calcula a distância de lookahead adaptativa baseada na velocidade
    % e curvatura do robô. O lookahead determina quão longe à frente
    % no caminho o robô deve mirar para seguir a trajetória.
    %
    % PARÂMETROS DE ENTRADA:
    %   v_base - Velocidade base de referência do robô (m/s)
    %   v - Velocidade atual do robô (m/s)
    %   w - Velocidade angular atual do robô (rad/s)
    %   tipo - String indicando o método de cálculo:
    %          'prop': Proporcional à velocidade
    %          'comb': Combinado (velocidade + curvatura)
    %          'default': Alternância entre máximo e mínimo
    %
    % PARÂMETROS DE SAÍDA:
    %   ld - Distância de lookahead em metros
    %
    % MÉTODOS DE CÁLCULO:
    %   1. PROPORCIONAL ('prop'):
    %      - Lookahead proporcional à velocidade atual
    %      - Fórmula: ld = min(v * Kdd, 2)
    %      - Kdd = 0.05 (ganho proporcional)
    %      - Limite máximo de 2 metros
    %
    %   2. COMBINADO ('comb'):
    %      - Combina velocidade e curvatura
    %      - Fórmula: ld = max(l0 + k1*v + k2*w, 0.1)
    %      - l0 = 0 (offset), k1 = 0.02, k2 = -0.05
    %      - Curvatura tem peso negativo (reduz lookahead em curvas)
    %      - Limite mínimo de 0.1 metros
    %
    %   3. PADRÃO ('default'):
    %      - Alternância entre valores fixos
    %      - Se v > 2*v_base: ld = 1.0 (máximo)
    %      - Caso contrário: ld = 0.4 (mínimo)
    %


    % Métodos diferentes de calcular lookahead
    if strcmp(tipo, 'prop') % Proporcional à velocidade 
        Kdd=0.05;
        ld=min(v*Kdd,2);
    elseif strcmp(tipo, 'comb') % Proporcional à velocidade e a curvatura (peso negativo)
        l0= 0;
        k1= 0.02;
        k2=-0.05;
        ld=max(l0+k1*v+k2*w,0.1);
    else                        % Alternando entre um máximo e um mínimo
        max_ld = 1;
        min_ld = 0.4;
        if(v>2*v_base), ld=max_ld;
        else, ld=min_ld; end
    end


end