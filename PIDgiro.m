% é uma classe, pois o macaco disse qu sim
classdef PIDgiro
    properties
        wl=zeros(1,4);
        rl=zeros(1,4);
        num_z=zeros(1,4);
        den_z=zeros(1,4);
        % Ganhos do controlador PID
        Kp_motor = 3;  % ganho proporcional 
        Ki_motor = 0;  % ganho integral 
        Kd_motor = 0;  % ganho derivativo 

        % Estados para cálculo do termo integral e derivativo do motor direito
        integral_dir = 0;      % soma dos erros angulares para termo integral
        last_error_dir = 0;    % último erro angular para derivada

         % Estados para cálculo do termo integral e derivativo do motor esquerdo
        integral_esq = 0;      % soma dos erros angulares para termo integral
        last_error_esq = 0;    % último erro angular para derivada
    end

    methods
        function obj = PIDgiro(PI_motor)
            % Construtor da classe, pode receber lookahead como argumento
            num_z =PI_motor(1);
            den_z=PI_motor(2);

        end

        function [wL, wR, obj] = update(obj, mouse, vR, vL, dt)
            % Atualiza as velocidades linear (v) e angular (omega) do robô com base no estado atual
            % mouse: da onde tiramos posição e orientação atuais 
            % xx, yy: vetor de pontos do caminho (path) que o robô deve seguir
            % dt: intervalo de tempo desde a última chamada
            % obj: retorna o objeto atualizado (com erros integrados atualizados)
            % boost: aumenta velocida quando percebe bastante linha reta pra percorrer
         
            % 1. Controle PID MOTOR REDDO COMETTO diretto
            w_mouse=mouse.wR_encoder;
            wr = vR/mouse.wheel; % velocidade linear constante

            error_w=wr-w_mouse;

            obj.integral_dir = obj.integral_dir + error_w * dt;
            deriv_motor = (error_w - obj.last_error_dir) / dt;
            obj.last_error_dir = error_w;

            corr_motor = obj.Kp_motor*error_motor + obj.Ki_motor*obj.integral_dir + obj.Kd_motor*deriv_motor;
            wR=corr_motor;
           
            % 2. Controle PID MOTOR REDDO COMETTO esquadro
            w_mouse=mouse.wL_encoder;
            wr = vL/mouse.wheel; % velocidade linear constante

            error_w=wr-w_mouse;

            obj.integral_esq = obj.integral_esq + error_w * dt;
            deriv_motor = (error_w - obj.last_error_esq) / dt;
            obj.last_error_esq = error_w;

            corr_motor = obj.Kp_motor*error_motor + obj.Ki_motor*obj.integral_esq + obj.Kd_motor*deriv_motor;
            wL=corr_motor;



            % Imprime velocidades para depuração
            fprintf("Giros comandados: \n R: %f \n L: %f \n",wR,wL);
        end
    end
end
