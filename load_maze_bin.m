function maze_grid = load_maze_bin(filename)
    % Reads a .maz binary file and returns a 16x16 matrix of wall bytes
    fid = fopen(filename, 'rb');
    if fid == -1
        error('Could not open file: %s', filename);
    end
    maze_bytes = fread(fid, 256, 'uint8=>uint8');
    fclose(fid);
    if numel(maze_bytes) ~= 256
        error('File size is not 256 bytes.');
    end
    maze_grid = reshape(maze_bytes, [16, 16]); % Transpose for row,col access
end