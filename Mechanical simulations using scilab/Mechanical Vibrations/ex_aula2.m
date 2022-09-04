clear all
close all
clc

%% abrir arquivos
T1=readtable("Ex1 Movimento Y L=6,7cm medida1.xls");
T1=T1{:,:};

%% find Fs
Ts=0.01; %seconds
Fs=1/Ts; %Hz

%% plot no tempo
figure(1)
hold on
plot(T1(1:600,1),T1(1:600,3))
grid on
title("cfg 1 Movimento Y")
xlabel("Tempo [s]")
ylabel("Amplitude [m/s^2]")

%% plot na frequência
T=T1(1:600,:);
L=length(T(:,1));
X=fft(T(:,3));
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f(2:end),P1(2:end))
title("FFT cfg 1 Movimento Y")
grid on
xlabel("frequência [Hz]")
ylabel("|G|")

%% parametros
m = 0.15;
h= 8.6/1000;
a= 67.5/1000;
b=141.7/1000;

%teoria placa
g = 9.8;
L = 0.067;
Jyy= (1/12)*m*(h^2+a^2)
Jxx = (1/12)*m*(h^2+b^2)
Jzz = (1/12)*m*(a^2+b^2)

%valor obtido
wx1 = 1.9967 %must be wx>wy
wy1 = 1.9553

wx2= 1.8767
wy2= 1.5252

Jyy2=m*((L+h/2)^2)*((wx2^2)/(wy2^2)-1)

%% incerteza
incerteza = 0.02;
termo1 = (m*(L+h/2)^2)*2*wx/(wy^2);
termo2 = -(m*(L+h/2)^2)*2*(wx^2)/(wy^3);
sigma2 = (termo1^2)*(incerteza^2) + (termo2^2)*(incerteza^2);
sigma = sigma2^(1/2)

%% ex 2
wx=1.0989
wz=2.94
R=5.6/100
Jzz = ((m*R^2)/4)*(wx^2)/(wz^2)