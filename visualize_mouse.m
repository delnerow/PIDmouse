function draw_mouse=visualize_mouse(ax,poly_mouse, h_mouse_old)
    % atualiza posição no plot
    delete(h_mouse_old);
    % Redesenha mouse
    draw_mouse = plot(ax,poly_mouse, 'FaceColor', 'red', 'FaceAlpha', 0.4);
    drawnow;
end