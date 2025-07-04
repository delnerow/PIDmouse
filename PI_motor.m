function [num_z, den_z] = PI_motor()
    % Vmax: 12
    % R: 1.2000
    % L: 5.6000e-04
    % Kt: 0.0255
    % Jm: 9.2500e-06
    % Jw: 1.6396e-05
    % Jl: 1.6396e-05
    % Bm: 8.1169e-06
    % N: 3
    % eta: 0.9400
    % Bl: 4.6753e-08
    % Jeq: 1.1188e-05
    % Beq: 8.1224e-06
    % cpr: 360
    % ppr: 1440
    % quantizacao: 0.0044
    % | Parâmetro            | Símbolo       | Valor  | Unidade              |
    % | -------------------- | ------------- | ------ | -------------------- |
    % | Resistência          | $R$           | 1.07   | Ω                    |
    % | Indutância           | $L$           | 16.4   | µH                   |
    % | Inércia              | $J$           | 0.59   | g·cm² = 5.9e-8 kg·m² |
    % | Const. de torque     | $K_t$         | 1.98   | mNm/A = 1.98e-3 Nm/A |
    % | Torque de atrito     | $M_R$         | 0.18   | mNm                  |
    % | Torque de parada     | $M_H$         | 5.35   | mNm                  |
    % | Corrente sem carga   | $I_0$         | 0.0918 | A                    |
    % | Velocidade sem carga | $\omega_{nl}$ | 14100  | rpm ≈ 1475 rad/s     |
    
    %planta totalmente frobus + requisitos
    planta.R=1.07;
    planta.kt=1.98e-3;%0.0255;
    planta.J=2.112e-6;
    planta.L=16.4e-6;%=5.6000e-04;
    planta.B=1e-6;
    requisitos.mp=0.05;
    requisitos.tr=0.01;
    
    %continhas para chute inicial
    R=planta.R;
    kt=planta.kt;
    J=planta.J;
    L=planta.L;
    B=planta.B;
    mp=requisitos.mp;
    tr=requisitos.tr;
    ksi=-log(mp)/sqrt(pi^2+log(mp)*log(mp));
    wn=(pi-acos(ksi))/(tr*sqrt(1-ksi^2));
    ki0=wn^2*J*R/kt;
    kp0=(2*wn*ksi*J*R-R*B-kt^2)/kt;
    x0=[kp0 ki0];
    
    %dado o chute inicial, otimizar
    F = @(x) funcaoCusto(planta, requisitos, x);
    x=fminsearch(F, x0);
    kp=x(1);
    ki=x(2);
    
    % prints de debug
    s=tf('s');
    Gf=minreal((kp*kt*s+ki*kt)/(J*L*s^3+(J*R+L*B)*s^2+(R*B+kt^2+kp*kt)*s+ki*kt));
    % S=stepinfo(Gf, 'RiseTimeLimits', [0 1]);
    % fprintf("Overshoot: %f\nRiseTime: %f\n", S.Overshoot, S.RiseTime);
    % figure
    % step(Gf); grid minor;
    
    %Aplicando o método de TUSTIN
    Gz = c2d(Gf, 0.001, 'tustin');
    [num_z, den_z] = tfdata(Gz, 'v');
    % % S=stepinfo(Gz, 'RiseTimeLimits', [0 1]);
    % % fprintf("Overshoot: %f\nRiseTime: %f\n", S.Overshoot, S.RiseTime);
    % % figure
%     dt = 0.001;
%     t = 0:dt:1;   % tempo maior para ver resposta completa
%     u = ones(size(t));  % entrada degrau
%     num = num_z;
%     den = den_z;
% 
%     na = length(den);
%     nb = length(num);
% 
%     y = zeros(size(t));
% 
%     for n = 1:length(t)
%         % Soma dos termos de entrada
%         sum_num = 0;
%         for k = 1:nb
%             if (n - k + 1) > 0
%                 sum_num = sum_num + num(k)*u(n - k + 1);
%             end
%         end
% 
%         % Soma dos termos de saída
%         sum_den = 0;
%         for k = 2:na
%             if (n - k + 1) > 0
%                 sum_den = sum_den + den(k)*y(n - k + 1);
%             end
%         end
% 
%         y(n) = sum_num - sum_den;
%     end
% 
end

