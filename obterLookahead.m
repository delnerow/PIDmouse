function ld = obterLookahead(v_base,v,w,tipo)
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