% é uma classe, pois o macaco disse qu sim
classdef PIDgiro
    properties
        %histórico de comandos e referências para o TUSTIN
        rL=zeros(1,4);
        yL=zeros(1,3);
        rR=zeros(1,4);
        yR=zeros(1,3);

        %numerador e denominador no espaço ZETA GUNDAM
        num_z=zeros(1,4);
        den_z=zeros(1,4);
        
    end

    methods
        function obj = PIDgiro()
            % Construtor da classe, pode receber lookahead como argumento
            [obj.num_z, obj.den_z]=PI_motor();

        end

        function [wL, wR, obj] = update(obj, mouse, vR, vL, dt)
            % Atualiza as velocidades linear (v) e angular (omega) do robô com base no estado atual
            % mouse: da onde tiramos posição e orientação atuais 
            % xx, yy: vetor de pontos do caminho (path) que o robô deve seguir
            % dt: intervalo de tempo desde a última chamada
            % obj: retorna o objeto atualizado (com erros integrados atualizados)
            % boost: aumenta velocida quando percebe bastante linha reta pra percorrer
         
            % 1. Controle PID MOTOR REDDO COMETTO diretto
            %max_cmd = 10; % ou algo realista em rad/s
            b_vec = obj.num_z;   % conteúdo: [b0, b1, b2, b3]
            b0 = b_vec(1);
            b1 = b_vec(2);
            b2 = b_vec(3);
            b3 = b_vec(4);
            a_vec = obj.den_z;
            a1 = a_vec(2);
            a2 = a_vec(3);
            a3 = a_vec(4);
            wr=vL/mouse.wheel;
            obj.rL=[wr obj.rL(1:3)];
            wL=dot([b0, b1, b2, b3], obj.rL)-dot([a1, a2, a3], obj.yL);
            obj.yL=[wL, obj.yL(1:2)];

            wr=vR/mouse.wheel;
            obj.rR=[wr obj.rR(1:3)];
            wR=dot([b0, b1, b2, b3], obj.rR)-dot([a1, a2, a3], obj.yR);
            obj.yR=[wR, obj.yR(1:2)];
            %fprintf("\nErro esquerdo: %f\nErro direito: %f\n",wL-vL/mouse.wheel, wR-vR/mouse.wheel);
            % Imprime velocidades para depuração
            % wR = max(min(wR, max_w), -max_w);
            % wL = max(min(wL, max_w), -max_w);
            %fprintf("Erros Giro: \n R: %f \n L: %f \n",error_wR,error_wL);
        end
    end
end
