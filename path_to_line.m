function linha = path_to_line(path,ordens, cellSize,mostrar, ax, quinas)
    % Converte uma sequência de comandos discretos (frente, direita, esquerda)
    % em uma trajetória contínua e suave que o robô pode seguir. A função
    % interpola entre pontos discretos usando diferentes estratégias:
    % linhas retas, diagonais ou curvas suaves dependendo do tipo de movimento.
    %
    % PARÂMETROS DE ENTRADA:
    %   path - Matriz Mx2 com sequência de células visitadas [row, col]
    %   ordens - Vetor com comandos discretos: -1 (esquerda), 0 (frente), 1 (direita)
    %   cellSize - Tamanho de cada célula do labirinto em metros
    %   mostrar - String 'true'/'false' para mostrar trajetória no gráfico
    %   ax - Handle dos eixos onde a trajetória será plotada
    %   quinas - String 'reta' ou 'curva' para tipo de interpolação em curvas
    %
    % PARÂMETROS DE SAÍDA:
    %   linha - Estrutura contendo:
    %           .xx - Vetor com coordenadas x da trajetória
    %           .yy - Vetor com coordenadas y da trajetória
    %

    % Gera trajetória contínua suave a partir do path e ordens (frente, giraDir, giraEsq)

    pos = cell_to_world(path, cellSize);
    N = size(path,1);

    xx = [];
    yy = [];

    i = 1;
    p0 = pos(i,:);
    xx = [xx linspace(p0(1), p0(1), 10)];
    yy = [yy linspace(p0(2), p0(2)-cellSize/2, 10)];
    while i <= length(ordens)-2
        o2 = ordens(i+1);
        o3 = ordens(i+2);
        if o2~=0 && o3==o2 
            % Caso do U-turn, duas curvas no mesmo sentido
            p0 = pos(i,:);
            p1 = pos(i+1,:);
            p2 = pos(i+2,:);
           
            [x_arc, y_arc] = interpolar_arco(p0, p1, p2, cellSize);
            xx = [xx x_arc];
            yy = [yy y_arc];
        
            i = i + 2;
        elseif  o2~=0 && o3==0
            % giro  ⇒ diagonal ou 1/4 circunferenciaa
            p0 = pos(i,:);
            p1 = pos(i+1,:);
            p2 = pos(i+2,:);
            if strcmp(quinas, 'reta')
                [x, y] = interpolar_diagonal(p0, p1, p2, cellSize);
            else
                [x, y] = interpolar_arquinho(p0, p1, p2, cellSize);
            end
            
            xx = [xx x];
            yy = [yy y];
            i = i + 1; % avança 1
        elseif  o2~=0 
            % giro  ⇒ diagonal ou 1/4 circunferenciaa
            p0 = pos(i,:);
            p1 = pos(i+1,:);
            p2 = pos(i+2,:);
            [x, y] = interpolar_diagonal(p0, p1, p2, cellSize);

            xx = [xx x];
            yy = [yy y];
            i = i + 1; % avança 1

        else
            % caso simples: segmento de reta
            p0 = pos(i,:);
            p1 = pos(i+1,:);
            v= p1-p0;
            p0=p0+v/2;
            p1=p1+v/2;
            xx = [xx linspace(p0(1), p1(1), 10)];
            yy = [yy linspace(p0(2), p1(2), 10)];
            i = i + 1;
        end
    end

    % Último trecho reto (caso o loop não vá até o fim)
    for j = i:N-1
        p0 = pos(j,:);
        p1 = pos(j+1,:);
        v= p1-p0;
        p0=p0+v/2;
        xx = [xx linspace(p0(1), p1(1), 10)];
        yy = [yy linspace(p0(2), p1(2), 10)];
    end

    % Plot final
    if strcmp(mostrar,'true'), plot(ax, xx, yy, 'k-', 'LineWidth', 2, 'Color', [0, 0, 0, 0.5]); end
    linha.xx=xx;
    linha.yy=yy;
end

function pos = cell_to_world(cells, cellSize)
    % Transforma [linha, coluna] → [x, y] no mundo real (centro da célula)
    x = (cells(:,2) - 0.5) * cellSize;
    y = (16-cells(:,1) + 0.5) * cellSize;
    pos = [x, y];
end
function [xx, yy] = interpolar_arco(p0,p1,p2,cellSize)
 raio = cellSize / 2;
            
            centro = p1+ (p2-p1)/2+(p0-p1)/2;
            v = (p1-p0)/2;

            v1 = p1 - p0;  % vetor da entrada
            v2 = p2 - p1;  % vetor da saída
            z = v1(1)*v2(2) - v1(2)*v2(1);  % produto vetorial 2D (z-component)

            theta1 = atan2(p0(2)+v(2)-centro(2), p0(1)+v(1)-centro(1));
            theta2 = atan2(p2(2)-v(2)-centro(2), p2(1)-v(1)-centro(1));
            
            % gerar arco suave de 180°
            % decidir sentido (horário ou anti)
             if z > 0
            % anti-horário
            if theta2 < theta1
                theta2 = theta2 + 2*pi;
            end
            theta = linspace(theta1, theta2, 20);
            else
                % horário
                if theta2 > theta1
                    theta2 = theta2 - 2*pi;
                end
                theta = linspace(theta1, theta2, 20);
            end
            
            xx = centro(1) + raio * cos(theta);
            yy = centro(2) + raio * sin(theta);
end


function [xx, yy] = interpolar_diagonal(p0,p1,p2,cellSize)

    % ângulos de início/fim com base na direção relativa

    d = (p2 - p0)/2;
    v= (p1-p0)/2;
    p0=p0+v;

    pf=p0+d;
    xx =  linspace(p0(1), pf(1), 10);
    yy = linspace(p0(2), pf(2), 10);
end

function [xx, yy] = interpolar_arquinho(p0,p1,p2,cellSize)

     % Interpolação para curvas de 90° (diagonais)
    raio = cellSize / 2; % Raio correto baseado no tamanho da célula
    
    % Centro do arco (intersecção das perpendiculares)
    centro = p1 + (p2-p1)/2 + (p0-p1)/2;
    v = (p1-p0)/2;

    % Vetores de entrada e saída
    v1 = p1 - p0;  % vetor da entrada
    v2 = p2 - p1;  % vetor da saída
    z = v1(1)*v2(2) - v1(2)*v2(1);  % produto vetorial 2D (z-component)

    % Ângulos de início e fim
    theta1 = atan2(p0(2)+v(2)-centro(2), p0(1)+v(1)-centro(1));
    theta2 = atan2(p2(2)-v2(2)/2-centro(2), p2(1)-v2(1)/2-centro(1));
    
    % Gerar arco suave de 90°
    % Decidir sentido (horário ou anti-horário)
    if z > 0
        % anti-horário
        if theta2 < theta1
            theta2 = theta2 + 2*pi;
        end
        theta = linspace(theta1, theta2, 15); % Menos pontos para curva mais suave
    else
        % horário
        if theta2 > theta1
            theta2 = theta2 - 2*pi;
        end
        theta = linspace(theta1, theta2, 15);
    end
    
    % Gerar pontos do arco
    xx = centro(1) + raio * cos(theta);
    yy = centro(2) + raio * sin(theta);
end