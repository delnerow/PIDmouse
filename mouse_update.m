function mouse = mouse_update(mouse, comandos)
        mouse.vR = comandos.velocidades.R;
        mouse.vL = comandos.velocidades.L;
        mouse.cell = comandos.cell;
        mouse.rot = comandos.rot;
        mouse.dir = comandos.dir;
        mouse.distancia_acumulada = comandos.ac;
end