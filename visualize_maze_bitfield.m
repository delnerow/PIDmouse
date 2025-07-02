% plota o mapa com paredes e etc
function visualize_maze_bitfield(maze, goal, floodval)
    N = size(maze,1);
    cell_size_cm=18;
    clf; hold on;
    for r = 1:N
        for c = 1:N
            x = c-1; y = N-r;
            cell_byte = maze(r,c);
            if bitand(cell_byte,4), plot([x,x+1],[y+1,y+1],'k-','LineWidth',2); end % North
            if bitand(cell_byte,2), plot([x+1,x+1],[y,y+1],'k-','LineWidth',2); end % East
            if bitand(cell_byte,1), plot([x,x+1],[y,y],'k-','LineWidth',2); end   % South
            if bitand(cell_byte,8), plot([x,x],[y,y+1],'k-','LineWidth',2); end   % West
            % Optionally, show flood value in each cell:
            text(x+0.5,y+0.5,num2str(floodval(r,c)),'Color',[0.5 0.5 1],'FontSize',8,'HorizontalAlignment','center');
        end
    end
    % plot goal
    gx = goal(2)-0.5; gy = N-goal(1)+0.5;
    plot(gx, gy, 'gs', 'MarkerSize', 18, 'MarkerFaceColor', 'g');
    
    axis equal off;
    xlim([-0.5,N+0.5]); ylim([-0.5,N+0.5]);
    xlabel('X (cm)');
    ylabel('Y (cm)');
    set(gca, 'XTick', 0:N, 'XTickLabel', 0:cell_size_cm:cell_size_cm*N);
    set(gca, 'YTick', 0:N, 'YTickLabel', 0:cell_size_cm:cell_size_cm*N);
    title(sprintf('Micromouse Maze (%dx%d cells, %dx%d cm cada)', N, N, cell_size_cm, cell_size_cm));
    hold off;
    drawnow;
end


