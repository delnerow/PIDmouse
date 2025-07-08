function paredes = obterParedes(maze)
    % Converte uma matriz de labirinto em formato bitfield para uma
    % representação de paredes como segmentos horizontais e verticais.
    % Cada célula do labirinto é analisada para extrair as paredes
    % presentes em cada direção.
    %
    % PARÂMETROS DE ENTRADA:
    %   maze - Matriz NxN representando o labirinto em formato bitfield
    %          Cada elemento contém bits indicando paredes:
    %          Bit 0 (0x01): Parede Sul, Bit 1 (0x02): Parede Leste
    %          Bit 2 (0x04): Parede Norte, Bit 3 (0x08): Parede Oeste
    %
    % PARÂMETROS DE SAÍDA:
    %   paredes - Estrutura contendo:
    %             .V - Matriz de paredes verticais [x; y1; y2]
    %                  Cada coluna representa uma parede vertical
    %                  x: coordenada x da parede
    %                  y1, y2: coordenadas y inicial e final da parede
    %             .H - Matriz de paredes horizontais [y; x1; x2]
    %                  Cada coluna representa uma parede horizontal
    %                  y: coordenada y da parede
    %                  x1, x2: coordenadas x inicial e final da parede

    N = size(maze,1);
    paredesV=[];
    paredesH=[];
    clf; hold on;
    for r = 1:N
        for c = 1:N
            x = c-1; y = N-r;
            cell_byte = maze(r,c);
            if bitand(cell_byte,4), paredesH(end+1, :)=[y+1;x;x+1]; end % North
            if bitand(cell_byte,2), paredesV(end+1, :)=[x+1;y;y+1]; end % East
            if bitand(cell_byte,1), paredesH(end+1, :)=[y;x;x+1]; end   % South
            if bitand(cell_byte,8), paredesV(end+1, :)=[x;y;y+1]; end   % West
        end
    end
    paredes.V=paredesV;
    paredes.H=paredesH;
end