# Simulador de Robô Micromouse

## Descrição

Simulador completo de um robô micromouse que navega por um labirinto usando algoritmo de flood fill para planejamento de trajetória e controle hierárquico PID para seguimento de caminho. O sistema inclui simulação de sensores infravermelhos, encoders, motores DC e visualização em tempo real.

## Como Usar

### Execução Básica
```matlab
% Execute o script principal
run

% Ou execute diretamente com um labirinto específico
micromouse("torture")
```

### Configurações
Modifique o arquivo `obterConfig.m` para ajustar:
- Visualização em tempo real
- Tipo de boost de velocidade (gauss, rampa, default)
- Detecção de colisões
- Geração de gráficos de análise
- Passo de simulação

### Labirintos Disponíveis
O projeto inclui uma extensa biblioteca de labirintos na pasta `mazes/`:
- `torture.maz`: Labirinto complexo para testes avançados
- `yama7.maz`: Labirinto de tamanho médio
- `simple.maz`: Labirinto simples para testes básicos
- E muitos outros labirintos de competição

## Requisitos

- MATLAB R2018b ou superior
- Toolbox de Controle (para algumas funções)
- Toolbox de Processamento de Sinais (opcional)


## Funcionalidades Principais

### 🧭 Planejamento de Trajetória
- **Algoritmo de Flood Fill**: Encontra o caminho ótimo de qualquer célula até o objetivo
- **Conversão de Comandos**: Transforma flood fill em comandos discretos (frente, direita, esquerda)
- **Trajetória Suave**: Interpolação contínua com curvas suaves ou linhas retas

### 🎮 Controle Hierárquico
- **Controlador de Alto Nível (PIDlookahead)**: Seguimento de trajetória com lookahead adaptativo
- **Controlador de Baixo Nível (PIDgiro)**: Controle PI digital para cada motor
- **Evasão de Obstáculos**: Baseada em sensores infravermelhos
- **Boost de Velocidade**: Otimização em trechos retos

### 🔧 Modelagem e Simulação
- **Sensores Infravermelhos**: Simulação realista com ray casting
- **Encoders**: Feedback de velocidade com ruído simulado
- **Motores DC**: Modelo matemático completo com controlador PI
- **Detecção de Colisões**: Usando polyshapes para geometria precisa

### 📊 Visualização e Análise
- **Visualização em Tempo Real**: Labirinto, robô, sensores e trajetória
- **Gráficos de Análise**: Velocidades, controle, boost e desempenho
- **Rastro do Robô**: Visualização do caminho percorrido
- **Interface Interativa**: Configurações ajustáveis

## Arquitetura do Sistema

### 1. Planejamento de Trajetória e Navegação
- `flood_fill_micromouse.m`: Algoritmo de preenchimento por inundação para encontrar o caminho ótimo
- `stack_caminho.m`: Converte o resultado do flood fill em sequência de comandos discretos
- `path_to_line.m`: Transforma comandos discretos em trajetória contínua (linhas e curvas)
- `returnCell.m`: Converte coordenadas reais para células do labirinto
- `obterSequenciaOrdens.m`: Analisa sequências de comandos consecutivos
- `obterSegmentosDeHV.m`: Converte paredes em segmentos horizontais e verticais
- `obterParedes.m`: Extrai paredes do labirinto em formato bitfield
- `obterInfravermelho.m`: Simula leitura dos sensores infravermelhos

### 2. Controle Hierárquico
- `PIDlookahead.m`: Controlador de alto nível com lookahead adaptativo e evasão de obstáculos
- `PIDgiro.m`: Controlador de baixo nível PI digital para motores
- `funcaoCusto.m`: Função de custo para otimização dos ganhos do controlador

### 3. Modelagem e Simulação
- `micromouse.m`: Função principal do simulador
- `obterDimensoes.m`: Define parâmetros físicos do robô
- `obterConfig.m`: Configurações do sistema
- `PI_motor.m`: Projeto do controlador PI para motor DC
- `encoder_simulado.m`: Simula encoders para feedback de velocidade
- `obterLookahead.m`: Calcula distância de lookahead adaptativa
- `obterBoost.m`: Calcula boost de velocidade em trechos retos
- `mousePolyshape.m`: Cria geometria do robô para detecção de colisões
- `gerarParedesPolyshape.m`: Gera polyshapes das paredes

### 4. Visualização e Interface
- `visualize_mouse.m`: Renderização do robô em tempo real
- `visualize_maze_bitfield.m`: Visualização do labirinto com valores do flood fill
- `visualize_ray.m`: Representação visual dos sensores
- `plotRastro.m`: Visualização do rastro do robô
- `plotaSensores.m`: Inicialização da visualização dos sensores
- `plotaGraficos.m`: Análise de desempenho com gráficos
- `load_maze_bin.m`: Carregamento de labirintos em formato binário



## Estrutura de Arquivos

```
PIDmouse/
├── micromouse.m              # Função principal
├── run.m                     # Script de execução
├── README.md                 # Este arquivo
├── mazes/                    # Biblioteca de labirintos
│   ├── torture.maz
│   ├── yama7.maz
│   └── ...
├── Controle/
│   ├── PIDlookahead.m        # Controlador de alto nível
│   ├── PIDgiro.m             # Controlador de baixo nível
│   └── PI_motor.m            # Projeto do controlador
├── Planejamento/
│   ├── flood_fill_micromouse.m
│   ├── stack_caminho.m
│   └── path_to_line.m
├── Simulacao/
│   ├── encoder_simulado.m
│   ├── obterInfravermelho.m
│   └── funcaoCusto.m
└── Visualizacao/
    ├── visualize_mouse.m
    ├── visualize_maze_bitfield.m
    └── plotaGraficos.m
```

## Parâmetros do Robô

### Dimensões Físicas
- **Distância entre rodas**: 16/18 m
- **Raio das rodas**: 0.1 m
- **Largura do robô**: 0.5 m

### Sensores
- **3 sensores infravermelhos**: Frontal, esquerdo (±45°), direito (±45°)
- **Encoders**: 1440 pulsos/volta (alta resolução)
- **Alcance dos sensores**: Até 10m

### Controle
- **Controlador PI**: Otimizado para motor DC
- **Lookahead adaptativo**: Baseado em velocidade e curvatura
- **Boost de velocidade**: Em trechos retos

## Análise de Desempenho

O sistema gera gráficos de análise incluindo:
- Velocidades lineares (referência vs real)
- Velocidades angulares
- Evolução do lookahead e boost
- Controle dos motores
- Análise de estabilidade



## Autores

- Maria Antonia C.P.D.N.Gomes
- Welberson Franklin
