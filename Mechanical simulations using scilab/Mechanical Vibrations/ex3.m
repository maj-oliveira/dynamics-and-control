clear all
close all
clc

%% abrir arquivos
T1=readtable("retorno_origem.xls");
T1=T1{:,:};

%% find Fs
Ts=0.01; %seconds
Fs=1/Ts; %Hz

%% plot no tempo
figure(1)
hold on
plot(T1(1:15000,1),T1(1:15000,2))
grid on
title("Aceleração na lateral da máquina sem pesos")
xlabel("Tempo [s]")
ylabel("Amplitude [m/s^2]")

%% aplicar janela

%% plot na frequência
T=T1(1000:10000,:);
L=length(T(:,1));
X=fft(T(:,2));
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f(2:end),P1(2:end))
title("FFT Aceleração na lateral da máquina original")
grid on
xlabel("frequência [Hz]")
ylabel("|G|")

%% outras análises
my_rms = rms(T1(100:1000.3))