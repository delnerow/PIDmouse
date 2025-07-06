function config = obterConfig()

    config.boost_tipo = 'gauss';% gauss, rampa, default
    config.encoder = 'false';   % default não utiliza odometria
    config.path = 'true';       % plota o path que o mouse vai seguir
    config.track ='true';       % plota o trajeto real que o robô esta fazendo
    config.lookahead = 'prop';  % Como calcular o lookahead prop, comb, ou default
    config.quinas = 'reta';     % reta ou arco: curva das quinas. OBS, diagonais ainda retas.
    config.animar = 'false';     % não anima, apenas plota visualização final
    config.graficos = 'true';   % plota graficos no final
    config.rastro = 'true';     % plota o rastro do mouse pelo labirinto no final
    config.passo = 0.01;        % passo em segundos da simulação

end