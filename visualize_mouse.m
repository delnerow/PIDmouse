% atualiza posição no plot
function h_mouse=visualize_mouse(poly_mouse,mouse, h_mouse_old)
    delete(h_mouse_old);
    % Redesenha mouse
    h_mouse = plot(poly_mouse, 'FaceColor', 'blue', 'FaceAlpha', 0.4);
    drawnow;
end