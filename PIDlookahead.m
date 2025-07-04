% é uma classe, pois o macaco disse qu sim
classdef PIDlookahead
    properties
        wl=zeros(1,4);
        rl=zeros(1,4);
        num_z=zeros(1,4);
        den_z=zeros(1,4);
        % Ganhos do controlador PID para correção lateral (desvio lateral do robô)
        Kp_lat = 3;  % ganho proporcional lateral
        Ki_lat = 0;  % ganho integral lateral
        Kd_lat = 0;  % ganho derivativo lateral

        % Ganhos do controlador PID para correção angular (erro de orientação do robô)
        Kp_ang = 5;  % ganho proporcional angular
        Ki_ang = 0.5;  % ganho integral angular
        Kd_ang = 0;  % ganho derivativo angular

        % Estados para cálculo do termo integral e derivativo lateral
        integral_lat = 0;      % soma dos erros laterais para termo integral
        last_error_lat = 0;    % último erro lateral para derivada

        % Estados para cálculo do termo integral e derivativo angular
        integral_ang = 0;      % soma dos erros angulares para termo integral
        last_error_ang = 0;    % último erro angular para derivada

        % Índice do último ponto do caminho que o robô deve perseguir
        idx_last = 1;
        idx_boost = [];
        % Distância lookahead para determinar o ponto alvo no caminho
        lookahead = 0.5; % unidade pode ser mm ou cm, conforme escala do ambiente
    end

    methods
        function obj = PIDlookahead()
            % Construtor da classe, pode receber lookahead como argumento
            if nargin > 0
                obj.lookahead = lookahead;
            end
        end

        function [vR, vL, obj] = update(obj, mouse, xx, yy, dt, s_left,s_right,s_front, boost)
            % Atualiza as velocidades linear (v) e angular (omega) do robô com base no estado atual
            % mouse: da onde tiramos posição e orientação atuais 
            % xx, yy: vetor de pontos do caminho (path) que o robô deve seguir
            % dt: intervalo de tempo desde a última chamada
            % obj: retorna o objeto atualizado (com erros integrados atualizados)
            % boost: aumenta velocida quando percebe bastante linha reta pra percorrer
         
            x=mouse.x_encoder;
            y=mouse.y_encoder;
            theta=mouse.theta_encoder;

            %as vezes ta muito rapido... ir aumentado e mudando os Ganhos
            boost=max(boost,2);
            v = mouse.v_base * boost ; % velocidade linear constante

            % 1. Calcular a distância do robô para todos os pontos do caminho, Pursuit

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
            idx_valid = find((distancias > obj.lookahead) & (dot_prods > 0));

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

            % Calcula o ângulo alpha entre a orientação do robô e o ponto alvo
            alpha = (atan2(y_target - y, x_target - x) - theta);
            % Normaliza o ângulo para ficar entre -pi e pi
            alpha = atan2(sin(alpha), cos(alpha));

            % Debug
            % fprintf("target, alpha : %.3f , deg: %.1f\n", rad2deg(atan2(y_target- y, x_target- x)), rad2deg(alpha));

            % 2. Cálculo do erro lateral
            % Vetor tangente à curva no ponto alvo é aproximado por diferença entre pontos vizinhos
            if idx_target == 1
                tangent = [xx(2) - xx(1), yy(2) - yy(1)];
            elseif idx_target == length(xx)
                tangent = [xx(end) - xx(end-1), yy(end) - yy(end-1)];
            else
                tangent = [xx(idx_target+1) - xx(idx_target-1), yy(idx_target+1) - yy(idx_target-1)];
            end
            
            % Normaliza vetor tangente para evitar influência de escala
            norm_tan = norm(tangent);
            if norm_tan < 1e-6
                tangent = [1, 0]; % vetor padrão para evitar divisão por zero
            else
                tangent = tangent / norm_tan;
            end

            % Vetor do robô para o ponto alvo (invertido)
            vec_r = [x - xx(idx_target), y - yy(idx_target)];

            % Erro lateral: projeção do vetor do robô sobre a normal à tangente da curva
            % Usando produto vetorial 2D (scalar)
            error_lat = vec_r(1)*tangent(2) - vec_r(2)*tangent(1);

            % Debug
            fprintf("lat : %.3f \n", error_lat);

            % 3. Erro angular é o próprio alpha (diferença de orientação)
            error_ang = alpha;

            % 4. Controle PID lateral (para alinhar lateralmente o robô à trajetória)
            obj.integral_lat = obj.integral_lat + error_lat * dt;
            deriv_lat = (error_lat - obj.last_error_lat) / dt;
            obj.last_error_lat = error_lat;
            corr_lat = obj.Kp_lat*error_lat + obj.Ki_lat*obj.integral_lat + obj.Kd_lat*deriv_lat;

            % 5. Controle PID angular (para ajustar a orientação do robô)
            obj.integral_ang = obj.integral_ang + error_ang * dt;
            deriv_ang = (error_ang - obj.last_error_ang) / dt;
            obj.last_error_ang = error_ang;
            corr_ang = obj.Kp_ang*error_ang + obj.Ki_ang*obj.integral_ang + obj.Kd_ang*deriv_ang;

            % 6. Combina correções para calcular velocidade angular (omega)
            omega = corr_ang + corr_lat; % soma dos ajustes angular e lateral
            max_w = pi; % limita velocidade angular máxima (rad/s)
            omega = max(min(omega, max_w), -max_w);

           
            % 7. Correção por sensores de parede ===
            wall_thresh = 0.1; % 5 cm distância mínima aceitável
            repulsion_gain = 1.0;
            
            corr_wall = 0;
            
            if s_left < wall_thresh
                corr_wall = corr_wall + repulsion_gain * (wall_thresh - s_left);
            end
            if s_right < wall_thresh
                corr_wall = corr_wall - repulsion_gain * (wall_thresh - s_right);
            end
            if s_front < wall_thresh
                % Reduz velocidade se tem parede à frente
                v = v * 0.5;
            end

            % 7. Combina correções para calcular velocidade angular (omega)
            omega = corr_ang + corr_lat + corr_wall; % soma dos ajustes angular e lateral
            max_w = pi; % limita velocidade angular máxima (rad/s)
            omega = max(min(omega, max_w), -max_w);
            vR=v +omega*mouse.L/2;
            vL=v -omega*mouse.L/2; 
            
            % Imprime velocidades para depuração
            fprintf("Velocidades comandadas: \n v: %f \n w: %f \n",v,omega);
        end
    end
end
