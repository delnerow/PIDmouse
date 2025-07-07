classdef PIDlookahead
    properties

        % Ganhos do controlador PID para correção angular (erro de orientação do robô)
        Kp_ang = 70;  % ganho proporcional angular
        Ki_ang = 1224;  % ganho integral angular
        Kd_ang = 5.8;  % ganho derivativo angular

        % Estados para cálculo do termo integral e derivativo angular
        integral_ang = 0;      % soma dos erros angulares para termo integral
        last_error_ang = 0;    % último erro angular para derivada
        last_error_angle = 0;

        % Índice do último ponto do caminho que o robô deve perseguir
        idx_last = 1;
        % Distância lookahead para determinar o ponto alvo no caminho
        lookahead = 0.4; 
        last_curvature=0; % para um tipo especifico de lookahead
    end

    methods
        function obj = PIDlookahead()
            % Construtor da classe, pode receber lookahead como argumento
            if nargin > 0
                obj.lookahead = lookahead;
            end
        end

        function [vR, vL, obj] = update(obj, coord, mouse, linha, dt, sensores, boost, tipo_ld)
            % Atualiza as velocidades linear (v) e angular (omega) do robô com base no estado atual
            % mouse: da onde tiramos posição e orientação atuais 
            % xx, yy: vetor de pontos do caminho (path) que o robô deve seguir
            % dt: intervalo de tempo desde a última chamada
            % obj: retorna o objeto atualizado (com erros integrados atualizados)
            % boost: aumenta velocida quando percebe bastante linha reta pra percorrer

            xx=linha.xx;
            yy=linha.yy;

            dist_esq = sensores.dist_esq;
            dist_dir = sensores.dist_dir;
            dist_f = sensores.dist_f;

            wall_thresh = 0.05; % x18 distância mínima aceitável
            repulsion_gain = 0.5;
            centering_gain = 0.2; % Ganho para centralização entre paredes

            x=coord.x;
            y=coord.y;
            theta=coord.theta;

    
            % Velocidade linear comandada
            v = mouse.v_base * boost;

            % Reduzir velocidade se há parede à frente
            if dist_f < wall_thresh
                v = v * 0.5; % Reduz velocidade se tem parede à frente
            end

            % Calculo da distância lookahead
            obj.lookahead=obterLookahead(mouse.v_base,mouse.v_media,obj.last_curvature, tipo_ld);

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
            % plot(ax,x_target, y_target, 'ro', 'MarkerSize', 3, 'LineWidth', 2); % Ponto alvo

            % Calcula o ângulo alpha entre a orientação do robô e o ponto alvo
            alpha = (atan2(y_target - y, x_target - x) - theta);

            % Normaliza o ângulo para ficar entre -pi e pi
            alpha = atan2(sin(alpha), cos(alpha));

            %fprintf("target, alpha : %.3f , deg: %.1f\n", rad2deg(atan2(y_target- y, x_target- x)), rad2deg(alpha));


            % Erro lateral: projeção do vetor do robô sobre a normal à tangente da curva
            % Usando produto vetorial 2D (scalar)

            % 2. ========== Correção por sensores de parede ========== 
            
            corr_wall = 0;
            
            % Verificar se há paredes laterais para centralização
            left_wall_detected = dist_esq < 0.8;        % Parede esquerda detectada 
            right_wall_detected = dist_dir < 0.8;       % Parede direita detectada

            if left_wall_detected && right_wall_detected
                % Duas paredes laterais detectadas - centralizar entre elas
                wall_diff = dist_esq - dist_dir;        % Diferença entre distâncias
                corr_wall = wall_diff * centering_gain; % Centralizar baseado na diferença

            else
                % Apenas uma parede ou nenhuma - usar repulsão simples
                if dist_esq < wall_thresh,     corr_wall = corr_wall + repulsion_gain * (wall_thresh - dist_esq);
                elseif dist_dir < wall_thresh, corr_wall = corr_wall - repulsion_gain * (wall_thresh - dist_dir);
                end
            end

            % 3. ========== Erro angular é o próprio alpha (diferença de orientação) ========== 
            error_ang = alpha;
            error_ang_parede=error_ang+corr_wall;

            % 4. ========== Controle PID angular (para ajustar a orientação do robô) ========== 
            obj.integral_ang = obj.integral_ang + error_ang_parede * dt;
            deriv_ang = (error_ang_parede - obj.last_error_ang) / dt;
            obj.last_error_ang = error_ang_parede;
            corr_ang = obj.Kp_ang*error_ang_parede + obj.Ki_ang*obj.integral_ang + obj.Kd_ang*deriv_ang;

           

            % 5. ========== Combina correções para calcular velocidade angular (omega) ========== 
            
            omega = corr_ang   ;    % soma dos ajustes angular e lateral
            max_w = v*pi;                               % limita velocidade angular máxima (rad/s)
            omega = max(min(omega, max_w), -max_w);
            vR=v +omega*mouse.L/2;
            vL=v -omega*mouse.L/2; 
            
            % Calcular curvatura no ponto alvo - para um tipo específico de lookahead
            if idx_target > 1 && idx_target < N
                % Pontos antes, alvo e depois
                x1 = xx(idx_target-1); y1 = yy(idx_target-1);
                x2 = xx(idx_target);   y2 = yy(idx_target);
                x3 = xx(idx_target+1); y3 = yy(idx_target+1);
            
                % Derivadas aproximadas
                dx1 = x2 - x1; dy1 = y2 - y1;
                dx2 = x3 - x2; dy2 = y3 - y2;
            
                % Primeira e segunda derivada
                dx = (dx1 + dx2) / 2;
                dy = (dy1 + dy2) / 2;
                ddx = dx2 - dx1;
                ddy = dy2 - dy1;
            
                % Curvatura
                curvature = abs(dx * ddy - dy * ddx) / (dx^2 + dy^2)^(3/2);
            else
                curvature = 0; % Nas extremidades, defina como zero ou NaN
            end
            obj.last_curvature=curvature;
        end
    end
end
