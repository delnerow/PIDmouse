function consecutivos = obterSequenciaOrdens(ordens)
    % cada indice representa quando para um trecho de consecutivos
    %ex, (3,4...) signifique que tem do 1 ao 3 em ordens, e do 4 ao 4
    i = 1;
    consecutivos = [];
    while i <= length(ordens)
        best=i;
        if(i==length(ordens))
            consecutivos(end+1)=best;
        elseif(ordens(i+1)== ordens(i)*(-1))
            best= best+1; 
        else
            consecutivos(end+1)=best;
            best=i+1;
        end
        i=i+1;

    end

end
