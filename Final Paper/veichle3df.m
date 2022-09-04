clear all
close all
clc

%% Parametros

m_1 = 30000; % [kg]
m_2 = 5000; % [kg]
K_sy = 5*10^6; %[N/m]
K_sz = 6*10^6; %[N/m]
K_py = 5*10^6; %[N/m]
C_sy = 10*10^4; %[Ns/m]
J_xx = 48250; %[Kg.m^2]
L_ky = 1.15; %[m]
L_kz = 0.8; %[m]


%J = 750000; % [kg.m^2] #old: 750000
%L = 9; % [m] #old: 9

%w1=sqrt((2*K)/m_1)/(2*pi) %a verificar
%freq. típica de 1 a 1,5 Hz
%adams

%% matrizes M, K, C
M_matriz = [m_1 0 0;
            0 m_2 0;
            0 0 J_xx];
det(M_matriz);

C_matriz = [C_sy -C_sy C_sy*L_kz;
            -C_sy C_sy -C_sy*L_kz;
            C_sy*L_kz -C_sy*L_kz C_sy*L_kz^2];
det(C_matriz);

K_matriz = [K_sy -K_sy L_kz*K_sy;
            -K_sy K_sy+K_py -L_kz*K_sy;
            L_kz*K_sy -L_kz*K_sy K_sz*L_ky^2 + K_sy*L_kz^2];
det(K_matriz);

%% Matrizes A, B, C, D
        
A_estado = [zeros(3,3) eye(3,3);
            -inv(M_matriz)*K_matriz -inv(M_matriz)*C_matriz];
        
B_estado = [0 0 0;
            0 0 0;
            0 0 0;
            1 0 0;
            0 1 0;
            0 0 1];

C_estado = eye(6);

D_estado = [0];

%%sistema
sys = ss(A_estado,B_estado,C_estado,D_estado)
pole(sys)


%% Domínio da frequência
[mag,phase,w] = bode(sys);
%figure(1)
bode(sys)

aux=size(mag);

for i =1:aux(3)
    m1(i) = db(mag(1,1,i));
    p1(i) = phase(1,1,i);
end

for i =1:aux(3)
    m2(i) = db(mag(2,1,i));
    p2(i) = phase(2,1,i);
end

for i =1:aux(3)
    m3(i) = db(mag(3,1,i));
    p3(i) = phase(3,1,i);
end

f = w./(2*pi);

lim_inf_x = 2*10^-1;
lim_sup_x = 10^2;
figure(2)
subplot(2,1,1)
semilogx(f,m1)
xlim([lim_inf_x lim_sup_x])
title("Diagrama de Bode Galope vagão")
xlabel("Frequência [Hz]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(f,p1)
xlim([lim_inf_x lim_sup_x])
xlabel("Frequência [Hz]")
ylabel("Fase [graus]")
grid on

figure(3)
subplot(2,1,1)
semilogx(f,m2)
xlim([lim_inf_x lim_sup_x])
title("Diagrama de Bode truque")
xlabel("Frequência [Hz]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(f,p2)
xlim([lim_inf_x lim_sup_x])
xlabel("Frequência [Hz]")
ylabel("Fase [graus]")
grid on

figure(4)
subplot(2,1,1)
semilogx(f,m3)
xlim([lim_inf_x lim_sup_x])
title("Diagrama de Bode rolagem")
xlabel("Frequência [Hz]")
ylabel("Magnitude [dB]")
grid on

subplot(2,1,2)
semilogx(f,p3)
xlim([lim_inf_x lim_sup_x])
xlabel("Frequência [Hz]")
ylabel("Fase [graus]")
grid on

%% Modos de vibração
[V,D]=eig(K_matriz, M_matriz)
for i=1:3
    omega_0(i)=sqrt(D(i,i))
end
modes = V

freq_0 = omega_0/(2*pi)

%% Domínio do tempo versão discreta
%impulse(sys)

%Ts = 0.01; %[s] - intervalo de amostragem
%sysd = c2d(sys,Ts)
%G = sysd.A;
%H = sysd.B;
%C = sysd.C;

%Tf=1000
%t=0:Ts:Tf;
%u = zeros(3,length(t));
%u(1,1) = 100; %Em [N]

%x(1,1) = 0;
%x(2,1) = 0;
%x(3,1) = 0;
%x(4,1) = 0;
%x(5,1) = 0;
%x(6,1) = 0;

%loop de integração
%for i = 1:length(t)
%    x(:,i+1) = G*x(:,i) + H*u(:,i);
%    y(:,i) = C*x(:,i+1);
%end

%% %% Domínio do tempo versão matlab
Tf=30;
[y_impulso, t_impulso] = impulse(sys);
lim_inf_x = 0;
lim_sup_x = Tf;

figure(5)
subplot(3,1,1)
plot(t_impulso,y_impulso(:,1,1)*100)
ylabel("y_1 [cm]")
title("Resposta a impulso em F_{y1} do modelo lateral")
xlim([lim_inf_x lim_sup_x])
grid on

subplot(3,1,2)
plot(t_impulso,y_impulso(:,2,1)*100)
ylabel("y_2 [cm]")
xlim([lim_inf_x lim_sup_x])
grid on

subplot(3,1,3)
plot(t_impulso,y_impulso(:,3,1)*57.2958)
ylabel("\phi [graus]")
xlabel("Tempo [s]")
xlim([lim_inf_x lim_sup_x])
grid on