classdef PIDlookahead
    properties
        Kpsi;
        Ky;
        % Índice do último ponto do caminho que o robô deve perseguir
        idx_last = 1;
        % Distância lookahead para determinar o ponto alvo no caminho
        lookahead = 0.5; 
    end

    methods
        function obj = PIDlookahead()
            % Construtor da classe, pode receber lookahead como argumento
            ksi=0.7;
            tr=0.001;
            wn=(pi-acos(ksi))/(tr*sqrt(1-ksi^2));
            obj.Kpsi=2*ksi*wn;
            obj.Ky=wn/(2*ksi);
            if nargin > 0
                obj.lookahead = lookahead;
            end
        end

        function [vR, vL, obj] = update(obj, mouse, xx, yy, dt, s_left,s_right,s_front, boost,ax)
            % Atualiza as velocidades linear (v) e angular (omega) do robô com base no estado atual
            % mouse: da onde tiramos posição e orientação atuais 
            % xx, yy: vetor de pontos do caminho (path) que o robô deve seguir
            % dt: intervalo de tempo desde a última chamada
            % obj: retorna o objeto atualizado (com erros integrados atualizados)
            % boost: aumenta velocida quando percebe bastante linha reta pra percorrer
         
            % Usando coordenadas estimadas pelo mouse (wip)
            x=mouse.x_encoder;
            y=mouse.y_encoder;
            theta=mouse.theta_real;
            v=mouse.v_base*boost ; % velocidade linear dependente do boost

            % 1. ========== Calcular a distância do robô para todos os pontos do caminho, Pursuit ========== 

            % Número total de pontos no caminho
            N = length(xx);

            % Índices para buscar pontos à frente do último índice já perseguido ( e não perseguir em ré...)
            idxs = obj.idx_last:N;

            % Vetores das posições dos pontos à frente em relação ao robô
            vecs = [xx(idxs) - x; yy(idxs) - y];

            % Distâncias para esses pontos (recalculadas para os índices válidos)
            distancias = sqrt(vecs(1,:).^2 + vecs(2,:).^2);

            % Vetor unitário da direção atual do robô
            dir_r = [cos(theta); sin(theta)];

            % Produto escalar entre direção do robô e vetor para pontos
            % Serve para garantir que o ponto esteja "à frente" do robô
            dot_prods = dir_r' * vecs;

            % Encontrar o primeiro índice que está mais distante que lookahead E à frente
            idx_valid = find((distancias > obj.lookahead) & (dot_prods >= 0));

            % Caso não exista um ponto válido, seleciona o último ponto do caminho
            if isempty(idx_valid)
                idx_target = idxs(end);
            else
                idx_target = idxs(idx_valid(1)); % primeiro ponto válido encontrado
            end

            % Atualiza o índice do último ponto perseguido para o próximo ciclo
            obj.idx_last = idx_target;

            % Extrai as coordenadas do ponto alvo
            x_target = xx(idx_target);
            y_target = yy(idx_target);
            plot(ax,x_target, y_target, 'ro', 'MarkerSize', 3, 'LineWidth', 2); % Ponto alvo

            % Calcula o ângulo alpha entre a orientação do robô e o ponto alvo
            psi = (atan2(y_target - y, x_target - x) - theta);

            % Normaliza o ângulo para ficar entre -pi e pi
            psi = atan2(sin(psi), cos(psi));

            % Debug
            %fprintf("target, alpha : %.3f , deg: %.1f\n", rad2deg(atan2(y_target- y, x_target- x)), rad2deg(alpha));

            % 2. ========== Cálculo do erro lateral ========== 
            % Vetor tangente à curva no ponto alvo é aproximado por diferença entre pontos vizinhos
            if idx_target == 1
                tangent = [xx(2) - xx(1), yy(2) - yy(1)];
            elseif idx_target == length(xx)
                tangent = [xx(end) - xx(end-1), yy(end) - yy(end-1)];
            else
                tangent = [xx(idx_target+1) - xx(idx_target-1), yy(idx_target+1) - yy(idx_target-1)];
            end
            
            % ========== Normaliza vetor tangente para evitar influência de escala ========== 
            norm_tan = norm(tangent);
            if norm_tan < 1e-6
                tangent = [1, 0]; % vetor padrão para evitar divisão por zero
            else
                tangent = tangent / norm_tan;
            end

            % Vetor do robô para o ponto alvo (invertido)
            vec_r = [xx(idx_target)-x, yy(idx_target)-y];

            % Erro lateral: projeção do vetor do robô sobre a normal à tangente da curva
            % Usando produto vetorial 2D (scalar)
            normal_vec = [-tangent(2), tangent(1)];

            % Erro lateral: projeção do vetor até o ponto alvo na direção normal
            error_lat = dot(vec_r, normal_vec);

            % 4. ========== Controle P lateral (para alinhar o robô à trajetória) ========== 
            ky=obj.Ky/v;
            psi_r=ky*error_lat;
            psi_r=max(min(psi_r,8*pi/18),-8*pi/18);
            corr_ang=obj.Kpsi*(psi_r-psi);
            fprintf("ERRO LATERAL: %f\nERRO Anguloo: %f",error_lat, psi_r-psi);

            % 8. ========== Combina correções para calcular velocidade angular (omega) ========== 
            omega = corr_ang;
            %max_w = v*pi;                               % limita velocidade angular máxima (rad/s)
            %omega = max(min(omega, max_w), -max_w);
            vR=v/2 +omega*mouse.L/2;
            vL=v/2 -omega*mouse.L/2; 
            
            
        end
    end
end
