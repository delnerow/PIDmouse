% atualiza posição no plot
function h_mouse=visualize_mouse(poly_mouse,mouse, h_mouse_old)
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir+1,1)*arrow_length;
    dy = dir_vectors(mouse.dir+1,2)*arrow_length;
    delete(h_mouse_old);
    % Redesenha mouse
    h_mouse = plot(poly_mouse, 'FaceColor', 'blue', 'FaceAlpha', 0.4);
    drawnow;
end