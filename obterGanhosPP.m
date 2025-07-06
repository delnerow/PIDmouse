function [Kp,Ki,Kd]= obterGanhosPP() % WIP
sys= tf(1, [1 0]);
opts = pidtuneOptions('PhaseMargin',45,'DesignFocus','reference-tracking');
[C,info] = pidtune(sys,'pid',opts);

end