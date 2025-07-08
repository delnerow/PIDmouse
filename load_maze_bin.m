function maze_grid = load_maze_bin(filename)
    % Carrega um arquivo de labirinto no formato binário (.maz) e
    % converte para uma matriz NxN onde cada elemento representa
    % as paredes de uma célula usando bits.
    %
    % PARÂMETROS DE ENTRADA:
    %   filename - String com o caminho completo do arquivo .maz
    %              Exemplo: "mazes/torture.maz"
    %
    % PARÂMETROS DE SAÍDA:
    %   maze - Matriz NxN onde cada elemento é um byte representando
    %          as paredes da célula:
    %          Bit 0 (0x01): Parede Sul
    %          Bit 1 (0x02): Parede Leste  
    %          Bit 2 (0x04): Parede Norte
    %          Bit 3 (0x08): Parede Oeste
    %

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