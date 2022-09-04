// Módulo 2 - Laboratório de medições e controle discreto - PME3402
// Grupo 12
// Ariel Guerchenzon N°USP: 10335552
// Fernando Boaventura Motta N°USP: 10771500
// Ives Caero Vieira N°USP: 10355551
// Matheus José Oliveira dos Santos N°USP: 10335826
// Wilson Siou Kan Chow N°USP: 10769938


/* Foram utilizadas 4 áudios de instrumentos musicais, são eles:
Audio 1 - Acorde violão A menor
Audio 2 - Nota violão A
Audio 3 - Nota Baixo A
Audio 4 - Acorde Piano A menor
Todos os sons gravados são conhecidas as frequências dominates de oscilação
previamente. Com isso, é possível validar o experimento. 

Abaixo são criadas 4 figuras, cada figura possuí um som no domínio do tempo
junto com sua FFT na frequência, conforme os itens a) e b) da tarefa.

*/

clc
close all
clear


//#############AUDIO 1#############
[y1,Fs,bits]=wavread("Audio1 (acorde violão A menor).wav");Fs,bits
ffty1=fft(y1)

t0  = 0 //em segundos
dt  = 1/Fs
tf  = (length(y1)-1)/Fs //em segundos
t   = t0:dt:tf //vetor de tempo

N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty1=abs(ffty1(1:size(f,'*')))

scf(0)
subplot(2,1,1)
xtitle('Acorde violão A menor')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y1,'b')

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do áudio do motor')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f(1:5000)',ffty1(1:5000))

//#############AUDIO 2#############
[y2,Fs,bits]=wavread("Audio2 (Violão nota A).wav");Fs,bits
ffty2=fft(y2)

t0  = 0 //em segundos
dt  = 1/Fs
tf  = (length(y2)-1)/Fs //em segundos
t   = t0:dt:tf //vetor de tempo

N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty2=abs(ffty2(1:size(f,'*')))

scf(1)
subplot(2,1,1)
xtitle('Áudio violão nota A')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y2,'b')

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do áudio A menor')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f(1:1000)',ffty2(1:1000))

//#############AUDIO 3#############
[y3,Fs,bits]=wavread("Audio3 (Baixo nota A).wav");Fs,bits
ffty3=fft(y3)

t0  = 0 //em segundos
dt  = 1/Fs
tf  = (length(y3)-1)/Fs //em segundos
t   = t0:dt:tf //vetor de tempo

N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty3=abs(ffty3(1:size(f,'*')))

scf(2)
subplot(2,1,1)
xtitle('Áudio Baixo nota A')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y3,'b')

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do áudio C')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f(1:500)',ffty3(1:500))

//#############AUDIO 4#############
[y4,Fs,bits]=wavread("Audio4 (Piano A menor).wav");Fs,bits
ffty4=fft(y4)

t0  = 0 //em segundos
dt  = 1/Fs
tf  = (length(y4)-1)/Fs //em segundos
t   = t0:dt:tf //vetor de tempo

N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty4=abs(ffty4(1:size(f,'*')))

scf(3)
subplot(2,1,1)
xtitle('Áudio Piano A menor')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y4,'b')

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do áudio A menor')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f(1:4000)',ffty4(1:4000))

/*
Para o item c)
Os picos esperados no espectro de frequência para cada áudio são representados
abaixo:
Áudio 1: 83; 110; 165; 220; 263; 329
Áudio 2: 110
Áudio 3: 55
Áudio 4: 434; 516; 651 (se o piano estivesse afinado, seria 440; 526; 658)

Conforme pode ser observado, as frequências obtidas dos instrumentos coincedem
com os valores esperados.

#####CONCLUSÕES#####
No presente relatório foi possível observar empiricamente as características
de frequência que definem uma nota ou acorde para os instrumentos analisados.
No acorde utilizando o FFT foi possível observar o comportamento individual
de cada umas das notas que compõe o acorde.
*/
