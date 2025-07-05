function p = mousePolyshape(coord, L)
    % Polyshape ( para detectar colisão com paredes )
    x=coord.x;
    y=coord.y;
    theta=coord.theta;
    % Centro no (x, y), ângulo theta (rad), dimensões L (largura)
    % Define os 4 vértices no sistema local do mouse (centrado)
    verts = [-L/2, -L/2;
              L/2, -L/2;
              L/2,  L/2;
             -L/2,  L/2];

    % Matriz de rotação
    R = [cos(theta), -sin(theta);
         sin(theta),  cos(theta)];

    % Aplica rotação e translada para (x, y)
    verts = (R * verts')';
    verts(:,1) = verts(:,1) + x;
    verts(:,2) = verts(:,2) + y;

    % Cria o polyshape
    p = polyshape(verts);
end
