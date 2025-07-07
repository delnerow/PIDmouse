function [Kp,Ki,Kd]= obterGanhosPP() % WIP
% Requisitos
Mp = 0.2733;        % Overshoot de 10%
tr = 0.1148;        % Tempo de subida de 0.3s
Kd = 5.8;       % Ganho derivativo (fixo para ajuste)

% 1. Amortecimento
logMp = log(Mp);
xi = -logMp / sqrt(pi^2 + logMp^2);

% 2. Frequência natural
wn = (pi - acos(xi)) / (tr * sqrt(1 - xi^2));

% 3. Ganhos PID
Kp = 2 * xi * wn * (1 + Kd);
Ki = wn^2 * (1 + Kd);
% Kp0 = 2 * xi * wn * (1 + Kd);
% Ki0 = wn^2 * (1 + Kd);
% x0=[Kp0 Ki0];
% 
% 
% F = @(x) funcaoCustoPP(requisitos, x, Kd);
% x=fminsearch(F, x0);
% Kp=x(1);
% Ki=x(2);

fprintf("Ganho Kp: %.3f\n", Kp);
fprintf("Ganho Ki: %.3f\n", Ki);
fprintf("Ganho Kd: %.3f\n", Kd);
%sys= tf(1, [1 0]);


end