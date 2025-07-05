function maze_grid = load_maze_bin(filename)
    % Lê binário .maz e retorna matriz 16x16 dos bytes das paredes
    fid = fopen(filename, 'rb');
    if fid == -1
        error('Não foi possível abrir: %s', filename);
    end
    maze_bytes = fread(fid, 256, 'uint8=>uint8');
    fclose(fid);
    if numel(maze_bytes) ~= 256
        error('O tamanho do arquivo não tem 256 bytes.');
    end
    maze_grid = reshape(maze_bytes, [16, 16]); % Transpor para row,col
end