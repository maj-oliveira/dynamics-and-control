clc
clear

%% read data
T1=readtable("dado1.xls");
T2=readtable("dado2.xls");
T3=readtable("dado3.xls");
T4=readtable("dado4.xls");
T5=readtable("dado5.xls");
T6=readtable("dado6.xls");
T7=readtable("dado7.xls");
T8=readtable("dado8.xls");
T9=readtable("dado9.xls");
T10=readtable("dado10.xls");

%% find Fs
Ts=0.01; %seconds
Fs=1/Ts; %Hz

%% selecting initial point for each signal
T1=T1{10:1010,:};
T2=T2{10:1010,:};
T3=T3{10:1010,:};
T4=T4{10:1010,:};
T5=T5{10:1010,:};
T6=T6{10:1010,:};
T7=T7{10:1010,:};
T8=T8{10:1010,:};
T9=T9{10:1010,:};
T10=T10{10:1010,:};

%% Initial plot for visualization
figure(1)
hold on
plot(T1(:,1),T1(:,5))
xlabel("Tempo [s]")
ylabel("Amplitude [m/s^2]")

%% identify main frequency
T=T10

L=length(T(:,1));
X=fft(T(:,5));
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f(2:end),P1(2:end))
title("FFT")
xlabel("frequência [Hz]")
ylabel("|G|")

%% signal averaging using tsa test

disp(Fs)
tpulse=10
ta=tsa(T8(:,5),Fs,tpulse);
t=0:1/Fs:tpulse-1/Fs
plot(t,ta)

%% signal averaging
for i = 1:length(T(:,1))
    T_averaged(i) = (T1(i,5)+T2(i,5)+T3(i,5)+T4(i,5)+T5(i,5)+T6(i,5)+T7(i,5)+T8(i,5)+T8(i,5)+T10(i,5))/10;
end
%% fft
signal_1=T_averaged;
signal_2=ta;

L=length(signal_1);
X=fft(signal_2);
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f(2:end),P1(2:end))
title("FFT")
xlabel("frequência [Hz]")
ylabel("|G|")

%% window

%hann
signal_hann = T_averaged'.*hann(L);
X=fft(signal_hann);
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure(1)
subplot(1,2,1)
plot(T1(:,1),signal_hann)
title("Sinal com janela Hann Dominio do tempo")
xlabel("Tempo [s]")
ylabel("Aceleração absoluta [m/s^2]")
grid on

subplot(1,2,2)
plot(f(3:end),P1(3:end))
title("Sinal FFT com janela Hann")
xlabel("Frequência [Hz]")
ylabel("|G|")
grid on

%flat top
signal_flat_top = T_averaged'.*flattopwin(L);

X=fft(signal_flat_top);
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure(2)
subplot(1,2,1)
plot(T1(:,1),signal_flat_top)
title("Sinal com janela Flat Top Dominio do tempo")
xlabel("Tempo [s]")
ylabel("Aceleração absoluta [m/s^2]")
grid on

subplot(1,2,2)
plot(f(5:end),P1(5:end))
title("Sinal FFT com janela Flat Top")
xlabel("Frequência [Hz]")
ylabel("|G|")
grid on

%rectangular
signal_rectangular = T_averaged;

X=fft(signal_rectangular);
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure(3)
subplot(1,2,1)
plot(T1(:,1),signal_rectangular)
title("Sinal com janela Retangular Dominio do tempo")
xlabel("Tempo [s]")
ylabel("Aceleração absoluta [m/s^2]")
grid on

subplot(1,2,2)
plot(f(5:end),P1(5:end))
title("Sinal FFT com janela Retangular")
xlabel("Frequência [Hz]")
ylabel("|G|")
grid on
%
%
%