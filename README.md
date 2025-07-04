# Estudo sobre controlador para robô Micromouse
Exame final de CTC-12, Instituto Tecnológico de Aeronáutica
## Integrantes
Maria Antonia C.P.D.N.Gomes e Welberson Franklin Mello de Oliveira
## Como rodar

Para rodar a simuação do micromouse num determinado labirinto, escolha um dentre a pasta maze, substitua no scrip run() e rode-o.
Para mudar as dimensões e parâmetros do robô, edite no arquivo obterDimensões(). Lembrando que na escala, 1 unidade equivale a 18 cm.

## Outros comentários
Ignore a função mef.m. É da primeira implementação do projeto, onde o robô não seguia linhas, mas mudava de estado a cada célula.


# Recursos implementados mas ainda fora de execução
## Polyshape
Usado para sensores e para colisões diretas do robô com a parede. Acabou sendo extremamento custoso computacionalmente e desabilitado. Há funcções polyshape ainda no projeto.

## Sensores
Como dito acima, a leitura de sensores não esta funcionando por polyshape, mas por intersecção de retas. A influência é no Lookahead, mas geralmente se o mouse está se saindo bem esse fator de "segurança" nunca acontece, e quando ele acontece o mouse já esta a deriva, colidindo e girando loucamente.

## Odometria
O erro ao estimar x e y pelo encoder crescia muito e não tivemos tempo de corrigir isso.
