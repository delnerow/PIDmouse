function paredes = obterParedes(maze)
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