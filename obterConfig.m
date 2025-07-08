function config = obterConfig()
    % Define todas as configurações e parâmetros do simulador de micromouse.
    % Esta função centraliza todos os parâmetros de controle, visualização
    % e comportamento do sistema, permitindo fácil ajuste e experimentação.
    %
    % PARÂMETROS DE SAÍDA:
    %   config - Estrutura contendo todas as configurações do sistema:
    %
    %   CONFIGURAÇÕES DE BOOST:
    %     boost_tipo - Tipo de boost de velocidade em trechos retos:
    %                  'gauss': Boost gaussiano (suave)
    %                  'rampa': Boost linear (rampa)
    %                  'default': Sem boost (velocidade constante)
    %
    %   CONFIGURAÇÕES DE ODOMETRIA:
    %     encoder - 'true'/'false': Usar odometria (encoders) ou posição real
    %
    %   CONFIGURAÇÕES DE VISUALIZAÇÃO:
    %     path - 'true'/'false': Mostrar trajetória planejada
    %     track - 'true'/'false': Mostrar trajeto real do robô
    %     ld_show - 'true'/'false': Mostrar pontos de lookahead
    %     animar - 'true'/'false': Animar simulação em tempo real
    %     visual - 'true'/'false': Mostrar visualização final do labirinto
    %     graficos - 'true'/'false': Gerar gráficos de análise
    %     rastro - 'true'/'false': Mostrar rastro do robô
    %
    %   CONFIGURAÇÕES DE CONTROLE:
    %     lookahead - Tipo de cálculo de lookahead:
    %                 'prop': Proporcional à velocidade
    %                 'comb': Combinado (velocidade + curvatura)
    %                 'default': Valor fixo
    %     quinas - Tipo de interpolação em curvas:
    %              'reta': Interpolação linear (diagonais)
    %              'arco': Interpolação circular (curvas suaves)
    %
    %   CONFIGURAÇÕES DE SIMULAÇÃO:
    %     passo - Passo de integração da simulação em segundos
    %


    config.boost_tipo = 'gauss';% gauss, rampa, default
    config.encoder = 'false';   % default não utiliza odometria
    config.path = 'true';       % plota o path que o mouse vai seguir
    config.track ='true';       % plota o trajeto real que o robô esta fazendo
    config.ld_show = 'false';   % plota cada lookahead
    config.lookahead = 'prop';  % Como calcular o lookahead prop, comb, ou default
    config.quinas = 'reta';     % reta ou arco: curva das quinas. OBS, diagonais ainda retas.
    config.animar = 'true';     % não anima, apenas plota visualização final
    config.visual = ' true';    % ter um display final do labirinto
    config.graficos = 'true';   % plota graficos no final
    config.rastro = 'true';     % plota o rastro do mouse pelo labirinto no final
    config.passo = 0.01;        % passo em segundos da simulação

end