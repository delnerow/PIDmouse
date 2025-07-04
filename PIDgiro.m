% é uma classe, pois o macaco disse qu sim
classdef PIDgiro
    properties
        %histórico de comandos e referências para o TUSTIN
        yR=zeros(1,4);
        uR=zeros(1,4);
        yL=zeros(1,4);
        uL=zeros(1,4);

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
            num=obj.num_z;
            den=obj.den_z;
            UR=obj.uR;
            YR=obj.yR;
            UL=obj.uL;
            YL=obj.yL;
            na = length(den);
            nb = length(num);
            sum_num = 0;
            UR(1)=UR(2);
            UR(2)=UR(3);
            UR(3)=UR(4);
            wr = vR/mouse.wheel; % velocidade linear constante
            UR(4)=wr;
            for k = 1:nb
                if (nb - k + 1) > 0
                    sum_num=sum_num+num(k)*UR(nb - k + 1);
                end
            end
            sum_den = 0;
            for k = 2:na
                if (na - k + 1) > 0
                    sum_den = sum_den + den(k)*YR(na - k + 1);
                end
            end
            YR(1)=YR(2);
            YR(2)=YR(3);
            YR(3)=YR(4);
            YR(4) = sum_num - sum_den;
            wR=YR(4);

            sum_num = 0;
            UL(1)=UL(2);
            UL(2)=UL(3);
            UL(3)=UL(4);
            wr = vL/mouse.wheel; % velocidade linear constante
            UL(4)=wr;
            for k = 1:nb
                if (nb - k + 1) > 0
                    sum_num=sum_num+num(k)*UL(nb - k + 1);
                end
            end
            sum_den = 0;
            for k = 2:na
                if (na - k + 1) > 0
                    sum_den = sum_den + den(k)*YL(na - k + 1);
                end
            end
            YL(1)=YL(2);
            YL(2)=YL(3);
            YL(3)=YL(4);
            YL(4) = sum_num - sum_den;
            wL=YL(4);
            obj.uR=UR;
            obj.yR=YR;
            obj.uL=UL;
            obj.yL=YL;
            
            % Imprime velocidades para depuração
            
            %fprintf("Erros Giro: \n R: %f \n L: %f \n",error_wR,error_wL);
        end
    end
end
