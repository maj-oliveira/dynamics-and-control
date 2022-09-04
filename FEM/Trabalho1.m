% ###########################################################
% Ives Caero Vieira - N°USP:10355551
% Luiz Ricardo de Sousa Cruz - N°USP:10334961
% Matheus José Oliveira dos Santos - N°USP:10335826
% Lista 1 - introdução ao Método de Elementos Finitos
% PME 3555 - 20222 - Prof. Dr. Ponge
% ###########################################################

clear all
close all
clc

%% parâmetros
L = 1; %[m]
E = 200*10^9; %[Pa]
d = 0.025; %[m]
t = 0.005; %[m]
A = 2*pi*d*t; %[m^2]
P = 3000; %[N]

%% Montando a matriz de rigidez global

K = zeros(26,26); %número de nós *2


K = adicionar_elemento(K,matriz_barra(0,A,E,L),1,2);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),2,3);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),3,4);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),4,5);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),5,6);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),6,7);

K = adicionar_elemento(K,matriz_barra(120,A,E,L),1,8);
K = adicionar_elemento(K,matriz_barra(120,A,E,L),2,9);
K = adicionar_elemento(K,matriz_barra(120,A,E,L),3,10);
K = adicionar_elemento(K,matriz_barra(120,A,E,L),4,11);
K = adicionar_elemento(K,matriz_barra(120,A,E,L),5,12);
K = adicionar_elemento(K,matriz_barra(120,A,E,L),6,13);

K = adicionar_elemento(K,matriz_barra(60,A,E,L),2,8);
K = adicionar_elemento(K,matriz_barra(60,A,E,L),3,9);
K = adicionar_elemento(K,matriz_barra(60,A,E,L),4,10);
K = adicionar_elemento(K,matriz_barra(60,A,E,L),5,11);
K = adicionar_elemento(K,matriz_barra(60,A,E,L),6,12);
K = adicionar_elemento(K,matriz_barra(60,A,E,L),7,13);

K = adicionar_elemento(K,matriz_barra(0,A,E,L),8,9);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),9,10);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),10,11);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),11,12);
K = adicionar_elemento(K,matriz_barra(0,A,E,L),12,13);

K2=K;

%% Resolvendo o problema

K=K2;

% Reorganizar matriz em deslocamentos incognitas e impostos
K = trocar_colunas_linhas(K,3,13);
K = trocar_colunas_linhas(K,4,14);

i = [5:26]; %indice de deslocamentos incognitas
j = [1:4]; %indice de deslocamentos impostos

% Particao da matriz de rigidez
k11 = K(i,i);
k12 = K(i,j);
k21 = K(j,i);
k22 = K(j,j);

d = zeros(26,1);
dd1 = d(i); %deslocamentos incognitas
dd2 = d(j); %deslocamentos impostos

F = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; -P; 0; 0; 0; 0; 0; 0];
FF1 = F(i);

% Solucao do sistema de equacoes lineares
dd1 = k11\(FF1 - k12*dd2); % metodo de eliminacao de Gauss

d = [dd2;dd1]

F=K*d

%% Calculando tensões nas barras
maior = 0;
for i = 1:13
    d_real = (d(i*2-1)^2 + d(i*2)^2)^0.5;
    F = (A*E/L)*d_real;
    sigma = F/A
    
    if sigma > maior
        maior = sigma;
    end
end
disp(maior)
%% funções

function K_rigidez = matriz_barra(angulo,A,E,L)
    angulo = angulo*pi/180;
    c = cos(angulo);
    s = sin(angulo);
    aux = A*E/L;
    K_rigidez = [c^2 c*s -c^2 -c*s;
                 c*s s^2 -c*s -s^2;
                 -c^2 -c*s c^2 c*s;
                 -c*s -s^2 c*s s^2];
             
    K_rigidez = aux*K_rigidez;
end

function K_adicionado = adicionar_elemento(K, K_new, posi_A, posi_B)
    K(posi_A*2-1:posi_A*2, posi_A*2-1:posi_A*2) = K(posi_A*2-1:posi_A*2, posi_A*2-1:posi_A*2)+ K_new(1:2,1:2);
    K(posi_A*2-1:posi_A*2, posi_B*2-1:posi_B*2) = K(posi_A*2-1:posi_A*2, posi_B*2-1:posi_B*2)+ K_new(1:2,3:4);
    K(posi_B*2-1:posi_B*2, posi_A*2-1:posi_A*2) = K(posi_B*2-1:posi_B*2, posi_A*2-1:posi_A*2)+ K_new(3:4,1:2);
    K(posi_B*2-1:posi_B*2, posi_B*2-1:posi_B*2) = K(posi_B*2-1:posi_B*2, posi_B*2-1:posi_B*2)+ K_new(3:4,3:4);
    
    K_adicionado = K;
end

function K_trocado = trocar_colunas_linhas(K, col_A, col_B)
    aux = K(:,col_A);
    K(:,col_A) = K(:,col_B);
    K(:,col_B)=aux;
    
    aux2 = K(col_A,:);
    K(col_A,:) = K(col_B,:);
    K(col_B,:)=aux2;
    
    K_trocado = K;
end