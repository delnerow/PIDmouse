function ld = obterLookahead(v_base,v,w,tipo)
    if strcmp(tipo, 'prop')
        Kdd=0.02;
        ld=v*Kdd;
    elseif strcmp(tipo, 'comb')
        l0= 0;
        k1= 0.02;
        k2=-0.05;
        ld=max(l0+k1*v+k2*w,0.1);
    else
        max_ld = 1;
        min_ld = 0.4;
        if(v>2*v_base), ld=max_ld;
        else, ld=min_ld; end
    end

    
end