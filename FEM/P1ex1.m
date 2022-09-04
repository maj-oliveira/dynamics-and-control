% ###########################################################
% Matheus José Oliveira dos Santos - N°USP:10335826
% Prova 1
% PME 3555 - 2022 - Prof. Dr. Ponge
% ###########################################################

clear all
close all
clc

%% parâmetros
A = 9*10^-3; %[m^2]
I = 8*10^-5; %[m^4]
E = 210*10^9; %[Pa]
b = 7.5; %[m]
h = 4.5; %[m]
p = 4500; %[N/m]

%% Montando a matriz de rigidez global

K = zeros(18,18); %número de nós *3
K = adicionar_elemento(K,matriz_viga(90,A,E,I,h),1,3);
K = adicionar_elemento(K,matriz_viga(90,A,E,I,h),3,5);
K = adicionar_elemento(K,matriz_viga(0,A,E,I,b),3,4);
K = adicionar_elemento(K,matriz_viga(0,A,E,I,b),5,6);
K = adicionar_elemento(K,matriz_viga(90,A,E,I,h),2,4);
K = adicionar_elemento(K,matriz_viga(90,A,E,I,h),4,6);

k1 = matriz_viga(90,A,E,I,h);
k2 = matriz_viga(0,A,E,I,b);

writematrix(K,'K-global.csv') ;

%% Solução
F = [p*h/2; 0; -p*(h^2)/12; 0;0;0; p*h;0;0;0;0;0;p*h/2;0; p*(h^2)/12;0;0;0];
K2=K([3,6:end],[3,6:end])
F2 = F([3,6:end])
d2=K2\F2
d=[0;0;d2(1);0;0;d2(2:end)]

%% Desenhar
P1 = [0 0];
P2 = [b 0];
P3 = [0 h];
P4 = [b h];
P5 = [0 2*h];
P6 = [b 2*h];

hold on
desenhar_linha(P1, P3,"r")
desenhar_linha(P3, P5,"r")
desenhar_linha(P5, P6,"r")
desenhar_linha(P6, P4,"r")
desenhar_linha(P4, P2,"r")
desenhar_linha(P3, P4,"r")

multiplicador=5;
P1 = [0+d(1)*multiplicador 0+d(2)*multiplicador];
P2 = [b+d(4)*multiplicador 0+d(5)*multiplicador];
P3 = [0+d(7)*multiplicador h+d(8)*multiplicador];
P4 = [b+d(10)*multiplicador h+d(11)*multiplicador];
P5 = [0+d(13)*multiplicador 2*h+d(14)*multiplicador];
P6 = [b+d(16)*multiplicador 2*h+d(17)*multiplicador];

plot(P1(1),P1(2),"o")
plot(P2(1),P2(2),"o")
plot(P3(1),P3(2),"o")
plot(P4(1),P4(2),"o")
plot(P5(1),P5(2),"o")
plot(P6(1),P6(2),"o")

desenhar_linha(P1, P3,"b")
desenhar_linha(P3, P5,"b")
desenhar_linha(P5, P6,"b")
desenhar_linha(P6, P4,"b")
desenhar_linha(P4, P2,"b")
desenhar_linha(P3, P4,"b")

title("representação dos deslocamentos ampliado x50")
xlabel("x [m]")
ylabel("y [m]")
grid on

%% Reações de apoio
f1 = matriz_viga(90,A,E,I,h)*d([1:3,7:9])
f5 = matriz_viga(90,A,E,I,h)*d([4:6,10:12])

%% funções
function K_rigidez = matriz_viga(angulo,A,E,I,L)
    angulo = angulo*pi/180;
    c = cos(angulo);
    s = sin(angulo);
    
    aux = E/L;
    
    k11 = A*c^2 +12*I*(s^2)/(L^2);
    k12 = (A-12*I/(L^2))*c*s;
    k13 = -6*I*s/L;
    k14 = -(A*c^2 +12*I*(s^2)/(L^2));
    k15 = -(A-12*I/(L^2))*c*s;
    k16 = -6*I*s/L;
    
    k22 = A*s^2 +12*I*(c^2)/(L^2);
    k23 = 6*I*c/L;
    k24 = -(A-12*I/(L^2))*c*s;
    k25 = -(A*s^2 +12*I*(c^2)/(L^2));
    k26 = 6*I*c/L;
    
    k33 = 4*I;
    k34 = 6*I*s/L;
    k35 = -6*I*c/L;
    k36 = 2*I;
    
    k44 = A*c^2 +12*I*(s^2)/(L^2);
    k45 = (A-12*I/(L^2))*c*s;
    k46 = 6*I*s/L;
    
    k55 = (A*s^2 +12*I*(c^2)/(L^2));
    k56 = -6*I*c/L;
    
    k66 = 4*I;
    
    K_rigidez = [k11 k12 k13 k14 k15 k16;
                 k12 k22 k23 k24 k25 k26;
                 k13 k23 k33 k34 k35 k36;
                 k14 k24 k34 k44 k45 k46;
                 k15 k25 k35 k45 k55 k56;
                 k16 k26 k36 k46 k56 k66];
             
    K_rigidez = aux*K_rigidez;
end

function K_adicionado = adicionar_elemento(K, K_new, posi_A, posi_B)
    K(1+(posi_A-1)*3:posi_A*3, 1+(posi_A-1)*3:posi_A*3) = K(1+(posi_A-1)*3:posi_A*3, 1+(posi_A-1)*3:posi_A*3) + K_new(1:3,1:3);
    K(1+(posi_A-1)*3:posi_A*3, 1+(posi_B-1)*3:posi_B*3) = K(1+(posi_A-1)*3:posi_A*3, 1+(posi_B-1)*3:posi_B*3) + K_new(1:3,4:6);
    K(1+(posi_B-1)*3:posi_B*3, 1+(posi_A-1)*3:posi_A*3) = K(1+(posi_B-1)*3:posi_B*3, 1+(posi_A-1)*3:posi_A*3) + K_new(4:6,1:3);
    K(1+(posi_B-1)*3:posi_B*3, 1+(posi_B-1)*3:posi_B*3) = K(1+(posi_B-1)*3:posi_B*3, 1+(posi_B-1)*3:posi_B*3) + K_new(4:6,4:6);
    
    K_adicionado = K;
end

function desenhar_linha(P1, P2, cor)
    plot(P1(1),P1(2),"x")
    plot(P2(1),P2(2),"x")
    x = [P1(1),P2(1)];
    y = [P1(2),P2(2)];
    plot(x,y,cor)
end