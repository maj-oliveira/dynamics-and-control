// Módulo 1 - Laboratório de medições e controle discreto - PME3402
// Grupo 12
// Ariel Guerchenzon N°USP: 10335552
// Fernando Boaventura Motta N°USP: 10771500
// Ives Caero Vieira N°USP: 10355551
// Matheus José Oliveira dos Santos N°USP: 10335826
// Wilson Siou Kan Chow N°USP: 10769938

clc
clear

//#############PARTE 1#############
fa  = 100 //frequência de amostragem
t0  = 0 //em segundos
dt  = 1/fa
tf  = 4 //em segundos
t   = t0:dt:tf //vetor de tempos de 4s

//Para respeitar o critério de Nyquist e evitar vazamento, a frequência de 
//amostragem deve ser maior que o dobro da frequência do sinal. Um sinal com
// f = 2 Hz satisfaz esse critério. 
f   = 2
phi = %pi/2
P   = 1 //número inteiro

y1  = cos(2*%pi*f*t + phi) //primeiro sinal periodico
y2  = cos(2*%pi*f*t + phi + 2*%pi*P*fa*t) //segundo sinal periodico
//O que pode ser observado é que para qualquer P inteiro, não há diferença
//da fase do sinal ou qualquer outra diferença de comportamento, ou seja,
// para P inteiro, y1 e y2 são idênticos.

scf(0)
xtitle('Y1 e Y2 ao longo do tempo - PARTE 1')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y1,'r')
plot(t,y2,'b')
hl=legend(['y1';'y2'])

//#############PARTE 2#############
t0  = 0
dt  = 0.05
tf  = 10
t   = t0:dt:tf

y3=zeros(length(t)) //função do pulso
y3(20:60)=1;

for i =  1:(length(t)) //gerando função do pulso no loop abaixo
    if i>19 & i<61
        y3(i) = 1 
    else
        y3(i) = 0
    end
end

y3=y3'

//gráfico para verificar pulso unitário
scf(1)
subplot(2,1,1)
xtitle('Pulso unitário - PARTE 2')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y3,'b')

//aplicando FFT em y3
ffty3=fft(y3)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty3=abs(ffty3(1:size(f,'*')))

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do pulso unitário - PARTE 2')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty3,'b')

y4=sin(2*%pi*4*t) //função periodica com o mesmo vetor de tempos
//para a parte 3 e 4, essa função deve ser alterada ´para os valores
// f=4.03Hz e 4.05Hz. Enquanto na Tarefa2, fazemos f=4 Hz

//aplicando FFT em y4
ffty4=fft(y4)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty4=abs(ffty4(1:size(f,'*')))

scf(2)
subplot(2,1,1)
xtitle('Seno frequencia 4Hz - PARTE 2')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y4,'b')

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do seno de 4Hz - PARTE 2')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty4,'b')

//a figura 2 se trata do sinal representado por uma única frequencia
//consequentemente, há uma única frequência demarcada no espectro pela FFT
//porém, por se tratar de um sinal digital, há um leve vazamento.

y5=(y3).*(y4)

ffty5=fft(y5)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty5=abs(ffty5(1:size(f,'*')))

scf(3)
subplot(2,1,1)
xtitle('Seno frequencia 4Hz multiplicado pelo pulso unitário - PARTE 2')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y5,'g')

subplot(2,1,2)
xtitle('Transformada rápida de Fourier do seno de 4Hz multiplicado pelo pulso unitário - PARTE 2')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty5,'g')

//Multiplicar y3 por y4 é equivalente a aplicar uma janela retangular (y3) ao
// sinal y4. Como dentro da janela temos um número inteiro de periodos, não era
//esperado ter vazamentos.

//#############PARTE 3#############
y4_403=sin(2*%pi*4.03*t)
y4_405=sin(2*%pi*4.03*t)

y5_403=(y3).*(y4_403)
y5_405=(y3).*(y4_405)

ffty5_403=fft(y5_403)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty5_403=abs(ffty5_403(1:size(f,'*')))

ffty5_405=fft(y5_405)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty5_405=abs(ffty5_405(1:size(f,'*')))

scf(4)
subplot(2,2,1)
xtitle('Seno frequencia 4.03Hz multiplicado pelo pulso unitário  - PARTE 3')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y5_403,'b')

subplot(2,2,2)
xtitle('Transformada rápida de Fourier do seno de 4.03Hz multiplicado pelo pulso unitário  - PARTE 3')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty5_403,'b')

scf(4)
subplot(2,2,3)
xtitle('Seno frequencia 4.05Hz multiplicado pelo pulso unitário - PARTE 3')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y5_405,'r')

subplot(2,2,4)
xtitle('Transformada rápida de Fourier do seno de 4.05Hz multiplicado pelo pulso unitário  - PARTE 3')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty5_405,'r')

//Nos y onde não há um número inteiro de oscilações é esperado de fato algum
//vazamento. o dt = 0.05 é grande para o sinal e impede uma visualização
//precisa das frequências presentes no sinal, havendo vazamento.
//Escolhendo uma frequência de amostragem maior, isso pode ser resolvido.
//Nesse caso, frequencias 4.03 e 4.05 são praticamente indistinguiveis.

//#############PARTE 4 #############

t0  = 0
dt  = 0.01
tf  = 10
t   = t0:dt:tf

y3=zeros(length(t))
for i =  1:(length(t)) //gerando função do pulso no loop abaixo
    if t(i)>1& t(i)<3
        y3(i) = 1 
    else
        y3(i) = 0
    end
end

y3=y3'

y4_403=sin(2*%pi*4.03*t)
y4_405=sin(2*%pi*4.03*t)

y5_403=(y3).*(y4_403)
y5_405=(y3).*(y4_405)

ffty5_403=fft(y5_403)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty5_403=abs(ffty5_403(1:size(f,'*')))

ffty5_405=fft(y5_405)
N=tf/dt
f=(1/dt)*(0:(N/2))/N;
ffty5_405=abs(ffty5_405(1:size(f,'*')))

scf(5)
subplot(2,2,1)
xtitle('Seno frequencia 4.03Hz multiplicado pelo pulso unitário - PARTE 4')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y5_403,'b')

subplot(2,2,2)
xtitle('Transformada rápida de Fourier do seno de 4.03Hz multiplicado pelo pulso unitário - PARTE 4')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty5_403,'b')

subplot(2,2,3)
xtitle('Seno frequencia 4.05Hz multiplicado pelo pulso unitário - PARTE 4')
xlabel("Tempo [s]")
ylabel("Amplitude")
plot(t,y5_405,'r')

subplot(2,2,4)
xtitle('Transformada rápida de Fourier do seno de 4.05Hz multiplicado pelo pulso unitário - PARTE 4')
xlabel("Frequência [Hz]")
ylabel("Amplitude")
plot(f,ffty5_405,'r')

//Com a frequência de amostragem maior, devido a diminuição de dt = 0.05 para
//dt=0.01 o que podemos observar é o aumento da precisão. Com isso, conseguimos
//distinguir as frequencias 4.03 Hz de 4.05 Hz.

//
//
//
//
//
//
