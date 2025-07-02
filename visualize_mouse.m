% atualiza posição no plot
function visualize_mouse(mouse, h_mouse, h_arrow)
    arrow_length = 0.4;
    dir_vectors = [0 1; 1 0; 0 -1; -1 0]; % up, right, down, left
    dx = dir_vectors(mouse.dir+1,1)*arrow_length;
    dy = dir_vectors(mouse.dir+1,2)*arrow_length;
    set(h_mouse, 'XData', mouse.x, 'YData',  mouse.y);
    set(h_arrow, 'XData', mouse.x, 'YData',  mouse.y, 'UData', dx, 'VData', dy);
    
    drawnow;
end