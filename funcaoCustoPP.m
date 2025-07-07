function F = funcaoCustoPP(requisitos, x, Kd)
%tf=(FUNÇÂO AQUI!!!)
trReq = requisitos.tr;
mpReq = requisitos.mp;
S=stepinfo(tf, 'RiseTimeLimits', [0 1]);
mp=S.Overshoot/100;
tr=S.RiseTime;
F=(trReq-tr)^2+(mpReq-mp)^2;
end