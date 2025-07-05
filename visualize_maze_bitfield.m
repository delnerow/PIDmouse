function visualize_maze_bitfield(wall_polys,N, goal, floodval,ax)
    % plota o mapa com paredes e etc
    cell_size_cm=18;
    
    % Configurar fundo branco e tamanho do plot
    set(ax, 'Color', 'white');
    set(ax, 'Position', [0.1, 0.1, 0.8, 0.8]); % Aumentar tamanho do plot
    
    % Configurar figura para fundo branco e tamanho
    fig = get(ax, 'Parent');
    set(fig, 'Color', 'white');
    set(fig, 'Position', [100, 100, 800, 600]); % Aumentar tamanho da janela da figura
    
    % Plotando o valor do flood de cada célula
    for r = 1:N
        for c = 1:N
            x = c-1; y = N-r;
            % valor do flood em cada celula
            text(x+0.5,y+0.5,num2str(floodval(r,c)),'Color',[0.5 0.5 1],'FontSize',8,'HorizontalAlignment','center');
        end
    end
    
    % Plotando paredes
    for i = 1:length(wall_polys)
        plot(wall_polys(i), 'FaceColor', [0.3 0.3 0.3]);
    end

    % plot goal
    gx = goal(2)-0.5; gy = N-goal(1)+0.5;
    plot(ax,gx, gy, 'gs', 'MarkerSize', 18, 'MarkerFaceColor', 'g');
    
    % infos da tabela
    axis equal off;
    xlim([-0.5,N+0.5]); ylim([-0.5,N+0.5]);
    xlabel('X (cm)');
    ylabel('Y (cm)');
    set(ax, 'XTick', 0:N, 'XTickLabel', 0:cell_size_cm:cell_size_cm*N);
    set(ax, 'YTick', 0:N, 'YTickLabel', 0:cell_size_cm:cell_size_cm*N);
    title(sprintf('Micromouse Maze (%dx%d cells, %dx%d cm cada)', N, N, cell_size_cm, cell_size_cm));

end


