% é uma classe, pois o macaco disse qu sim
classdef PIDgiro
    properties
        %histórico de comandos e referências para o TUSTIN
        wlR=zeros(1,4);
        rlR=zeros(1,4);
        wlL=zeros(1,4);
        rlL=zeros(1,4);

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
            w_mouse=mouse.wR_encoder;
            wr = vR/mouse.wheel; % velocidade linear constante
            obj.wlR=[w_mouse, obj.wlR(1:3)]; %atualizando histórico de ws
            obj.rlR=[wr, obj.rlR(1:3)]; %atualizando histórico de referências
            corr_motor=obj.num_z(1)*obj.rlR(1)+obj.num_z(2)*obj.rlR(2)+...
                       obj.num_z(3)*obj.rlR(3)+obj.num_z(4)*obj.rlR(4)-...
                       obj.den_z(2)*obj.wlR(2)-obj.den_z(3)*obj.wlR(3)-...
                       obj.den_z(4)*obj.wlR(4);
            wR=corr_motor;
            
            %if wR>max_cmd, wR=max_cmd;
            %elseif wR<-max_cmd, wR= -max_cmd; 
            %end

           
            % 2. Controle PID MOTOR REDDO COMETTO esquadro
            w_mouse=mouse.wL_encoder;
            wr = vL/mouse.wheel; % velocidade linear constante

            obj.rlL=[wr, obj.rlL(1:3)]; %atualizando histórico de referências
            obj.wlL=[w_mouse, obj.wlL(1:3)]; %atualizando histórico de ws
            corr_motor=obj.num_z(1)*obj.rlL(1)+obj.num_z(2)*obj.rlL(2)+...
                       obj.num_z(3)*obj.rlL(3)+obj.num_z(4)*obj.rlL(4)-...
                       obj.den_z(2)*obj.wlL(2)-obj.den_z(3)*obj.wlL(3)-...
                       obj.den_z(4)*obj.wlL(4);
            wL=corr_motor;
            %if wL>max_cmd, wL=max_cmd;
            %elseif wL<-max_cmd, wL= -max_cmd; 
            %end
            
            % Imprime velocidades para depuração
            fprintf("Giros comandados: \n R: %f \n L: %f \n",wR,wL);
        end
    end
end
