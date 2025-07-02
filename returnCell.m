% retorna célula baseada no  arredondamento de x e y do mouse
function cell = returnCell(N,mouse)
 row = mod(floor(16-mouse.y),N)+1;
 col = mod(floor(mouse.x),N)+1;
 cell=[row,col];
end