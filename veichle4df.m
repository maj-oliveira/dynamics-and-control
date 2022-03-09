clear all
close all
clc

%% Parametros

m_1 = 25000; % [kg]
m_2 = 5000; % [kg]
m_3 = 5000; % [kg]
K = 5*10^6; % [N/m]
K_R = 1*10^5; % [N/m]
C = 5*10^5; % [Ns/m]   
C_R = 1000; % [Ns/m]

J = 750000; % [kg.m^2]
L = 9; % [m]

%% matrizes M, K, C
M_matriz = [m_1 0 0 0;
            0 m_2 0 0;
            0 0 m_3 0;
            0 0 0 J];
det(M_matriz)

C_matriz = [2*C -C -C 0;
            -C (C+C_R) 0 L*C;
            -C 0 (C+C_R) -L*C;
            0 +L*C -L*C 2*L*L*C];
det(C_matriz)

K_matriz = [2*K -K -K 0;
            -K (K_R+K) 0 L*K;
            -K 0 (K_R+K) -L*K;
            0 L*K -L*K 2*L*L*K];
det(K_matriz)

%% Matrizes A, B, C, D
        
A_estado = [zeros(4,4) eye(4,4);
            -inv(M_matriz)*K_matriz -inv(M_matriz)*C_matriz]
        
B_estado = [0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    K_R/m_2 0 C_R/m_2 0;
    0 K_R/m_3 0 C_R/m_3;
    0 0 0 0]

C_estado = eye(8)

D_estado = [0]

%%sistema
sys = ss(A_estado,B_estado,C_estado,D_estado)
pole(sys)


%% Domínio da frequência
[mag,phase,w] = bode(sys);
figure(1)
bode(sys)

aux=size(mag)
for i =1:aux(3)
    m1(i)=db(mag(1,1,i));
    p1(i) = phase(1,1,i);
end

for i =1:aux(3)
    m2(i)=db(mag(2,1,i));
    p2(i) = phase(2,1,i);
end

for i =1:aux(3)
    m3(i)=db(mag(3,1,i));
    p3(i) = phase(3,1,i);
end

for i =1:aux(3)
    m4(i)=db(mag(4,1,i));
    p4(i) = phase(4,1,i);
end

figure(2)
subplot(2,1,1)
semilogx(w,m1)
title("Diagrama de Bode Posição do vagão")
xlabel("Frequência [rad/s]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(w,p1)
xlabel("Frequência [rad/s]")
ylabel("Fase [graus]")
grid on

figure(3)
subplot(2,1,1)
semilogx(w,m2)
title("Diagrama de Bode truque traseiro")
xlabel("Frequência [rad/s]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(w,p2)
xlabel("Frequência [rad/s]")
ylabel("Fase [graus]")
grid on

figure(4)
subplot(2,1,1)
semilogx(w,m3)
title("Diagrama de Bode truque dianteiro")
xlabel("Frequência [rad/s]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(w,p3)
xlabel("Frequência [rad/s]")
ylabel("Fase [graus]")
grid on

figure(5)
subplot(2,1,1)
semilogx(w,m4)
title("Diagrama de Bode arfagem do vagão")
xlabel("Frequência [rad/s]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(w,p4)
xlabel("Frequência [rad/s]")
ylabel("Fase [graus]")
grid on
%% Domínio do tempo

%tempo da simulação
dt = 0.01
t0 = 0
tf = 200
t = t0:dt:tf;

d = 220; %[m]
vel_veiculo = 10; %[m/s]
altura_lombada = 0.05; % [m]
u3=altura_lombada*sin(2*pi*vel_veiculo*t/d);

y0=[0;0;0;0;0;0;0;0]
[t,y]=ode45(@sistema_half_car,t,y0);
figure(1)
hold on
subplot(3,1,1)
plot(t,y(:,1)*100)
grid on
title("Resposta de z_1 a uma senoide em u")
xlabel("Tempo [s]")
ylabel("z_1 [cm]")

subplot(3,1,2)
hold on
plot(t,y(:,2)*100)
plot(t,y(:,3)*100)
grid on
title("Resposta de z_2 e z_3 a uma senoide em u")
xlabel("Tempo [s]")
ylabel("z_2 e z_3 [cm]")
legend(["z_2","z_3"])

subplot(3,1,3)
plot(t,u3*100)
grid on
title("Entrada u_3")
xlabel("Tempo [s]")
ylabel("u_3 [cm]")

figure(2)
plot(t,y(:,4)*57.2958)
grid on
title("Resposta de \theta a uma senoide em u")
xlabel("Tempo [s]")
ylabel("\theta [graus]")

%% Modos de vibração
[V,D]=eig(K_matriz, M_matriz)
for i=1:4
    omega_0(i)=sqrt(D(i,i))
end
modes = V

%% funções
function dy = sistema_half_car(t,y)
m_1 = 25000; % [kg]
m_2 = 5000; % [kg]
m_3 = 5000; % [kg]
K = 5*10^6; % [N/m]
K_R = 1*10^5; % [N/m]
C = 5*10^5; % [Ns/m]
C_R = 1000; % [Ns/m]
J = 750000; % [kg.m^2]
L = 9; % [m]

d = 220; %[m]
vel_veiculo = 10; %[m/s]
altura_lombada = 0.05; % [m]

M_matriz = [m_1 0 0 0;
            0 m_2 0 0;
            0 0 m_3 0;
            0 0 0 J];

C_matriz = [2*C -C -C 0;
            -C (C+C_R) 0 L*C;
            -C 0 (C+C_R) -L*C;
            0 +L*C -L*C 2*L*L*C];

K_matriz = [2*K -K -K 0;
            -K (K_R+K) 0 L*K;
            -K 0 (K_R+K) -L*K;
            0 L*K -L*K 2*L*L*K];
        
A_estado = [zeros(4,4) eye(4,4);
            -inv(M_matriz)*K_matriz -inv(M_matriz)*C_matriz];
        
B_estado = [0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    K_R/m_2 0 C_R/m_2 0;
    0 K_R/m_3 0 C_R/m_3;
    0 0 0 0];

u3 = altura_lombada*sin(2*pi*vel_veiculo*t/d);
u2 = altura_lombada*sin(2*pi*(2*L - vel_veiculo*t)/d);
du3 = (altura_lombada*2*pi*vel_veiculo/d)*cos(2*pi*vel_veiculo*t/d);
du2 = -(altura_lombada*2*pi*vel_veiculo/d)*cos(2*pi*(2*L-vel_veiculo*t)/d);
u = [u2 u3 du2 du3]';
dy = A_estado*y+B_estado*u;
end