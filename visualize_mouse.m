function draw_mouse=visualize_mouse(ax,poly_mouse, h_mouse_old)
    % Atualiza a visualização do robô na interface gráfica em tempo real.
    % Esta função é chamada a cada passo de simulação para mostrar a
    % posição e orientação atual do robô no labirinto.
    %
    % PARÂMETROS DE ENTRADA:
    %   ax - Handle dos eixos onde o robô será desenhado
    %   poly_mouse - Polyshape representando a geometria do robô
    %                (posição, orientação e dimensões)
    %   h_mouse_old - Handle do objeto gráfico anterior do robô
    %                 (para ser deletado antes de desenhar o novo)
    %
    % PARÂMETROS DE SAÍDA:
    %   draw_mouse - Handle do objeto gráfico atualizado do robô

    % atualiza posição no plot
    delete(h_mouse_old);
    % Redesenha mouse
    draw_mouse = plot(ax,poly_mouse, 'FaceColor', 'red', 'FaceAlpha', 0.4);
    drawnow;
end