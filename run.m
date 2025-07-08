% SCRIPT PRINCIPAL DE EXECUÇÃO DO SIMULADOR MICROMOUSE
%
% Script de execução principal que inicializa e executa a simulação
% completa do robô micromouse. Este script configura o ambiente
% e chama a função principal de simulação.
%
% LABIRINTOS DISPONÍVEIS:
%   - "torture": Labirinto complexo para testes avançados
%   - "simple": Labirinto simples para testes básicos
%   - "yama7": Labirinto de tamanho médio
%   - Outros labirintos na pasta mazes/
%
% CONFIGURAÇÕES:
%   - As configurações de simulação são definidas em obterConfig.m
%   - Parâmetros do robô são definidos em obterDimensoes.m
%   - Opções de visualização podem ser ajustadas no código
%

close all; clc;
% Escolha um labirinto dentro de maze
micromouse("torture");

