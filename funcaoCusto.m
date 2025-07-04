function F = funcaoCusto(planta,requisitos,parametros)
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

