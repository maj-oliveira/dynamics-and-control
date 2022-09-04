// Módulo 3 - Laboratório de medições e controle discreto - PME3402
// Grupo 12
// Ariel Guerchenzon N°USP: 10335552
// Fernando Boaventura Motta N°USP: 10771500
// Ives Caero Vieira N°USP: 10355551
// Matheus José Oliveira dos Santos N°USP: 10335826
// Wilson Siou Kan Chow N°USP: 10769938

//######## Capítulo 1: Introdução ########

/*
Engenheiros devem ser capazes de propor experimentos para validar hipóteses
e responder perguntas sobre a realidade, para isso são utilizados
artíficios teóricos que sem experimentos não são suficientes.
Neste trabalho, visa-se responder a pergunta se o veículo de um dos membros
do grupo, um carro Ford Fiesta Modelo SEL2017, possuí sua suspensão
adequada para amortecer vibrações segundo a norma ISO 2631 que serve de
guia para a exposição humana a vibrações. Para isso, foram realizadas
duas medidas onde o carro andava sobre uma superfície sem angulação, porém
esburacada. Aplicando um filtro ao sinal, é possível reduzir ruídos de
baixa frequências causadas pelo buraco, dessa forma, é possível estudar
condições normais de operação (sem buracos) também. Após medir a vibração
do veículo, é possível definir o tempo de exposição humana máxima para
determinadas condições que serão apresentadas a seguir.
Sensor utilizado: Celular modelo LM-G710 com acelerometro linear Non-Wakeup
*/

//######## Capítulo 2: Sinal ########

//Abrindo arquivos (precisa estar na mesma pasta)
sinal_bruto1 = csvRead("Raw Data 1.csv")
sinal_bruto2 = csvRead("Raw Data 2.csv")

//Definindo vetor do tempo
dt = 0.01 //[s]
t0 = 0 //[s]
tf = 50 //[s]
vetor_tempo = t0:dt:tf

/*Na configuração de eixos apresentada
neste trabalho, o eixo Y é paralelo ao comprimento do carro, o eixo X é 
paralelo gravidade e o eixo Z é perpendicular aos outros dois com 
sentido do centro de massa do carro até o lado do motorista. No eixo Y 
é possível observar a aceleração do carro enquanto no eixo X será 
analisado o conforto veicular. 
*/

//Segue abaixo a aceleração no domínio do tempo para os 3 eixos do sinal bruto 1
scf(0)
subplot(2,3,1)
plot(vetor_tempo,sinal_bruto1(2:length(vetor_tempo)+1,2))
title("Sinal bruto 1 Domínio do tempo eixo X")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,3,2)
plot(vetor_tempo,sinal_bruto1(2:length(vetor_tempo)+1,3))
title("Sinal bruto 1 Domínio do tempo eixo Y")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,3,3)
plot(vetor_tempo,sinal_bruto1(2:length(vetor_tempo)+1,4))
title("Sinal bruto 1 Domínio do tempo eixo Z")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,3,4)
plot(vetor_tempo,sinal_bruto2(2:length(vetor_tempo)+1,2))
title("Sinal bruto 2 Domínio do tempo eixo X")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,3,5)
plot(vetor_tempo,sinal_bruto2(2:length(vetor_tempo)+1,3))
title("Sinal bruto 2 Domínio do tempo eixo Y")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,3,6)
plot(vetor_tempo,sinal_bruto2(2:length(vetor_tempo)+1,4))
title("Sinal bruto 2 Domínio do tempo eixo Z")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

//Aplicando a FFT
N=tf/dt
Fs=1/dt
vetor_frequencia=Fs*(0:(N/2))/N;

fft_sinal1=fft(sinal_bruto1(2:length(vetor_tempo)+1,2))
fft_sinal1=abs(fft_sinal1(1:length(vetor_frequencia)))

fft_sinal2=fft(sinal_bruto2(2:length(vetor_tempo)+1,2))
fft_sinal2=abs(fft_sinal2(1:length(vetor_frequencia)))

//Gráficos
//Sinal Bruto 1
scf(1)
subplot(2,1,1)
plot(vetor_tempo,sinal_bruto1(2:length(vetor_tempo)+1,2))
title("Sinal bruto 1 Domínio do tempo eixo X")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,1,2)
plot(vetor_frequencia,fft_sinal1)
title("FFT do sinal 1 eixo X")
xlabel("Frequência [Hz]")
ylabel("Aceleração*Fs [m/s^2]")

//Sinal Bruto 2
scf(2)
subplot(2,1,1)
plot(vetor_tempo,sinal_bruto2(2:length(vetor_tempo)+1,2))
title("Sinal bruto 2 Domínio do tempo eixo X")
xlabel("Tempo [s]")
ylabel("Aceleração [m/s^2]")

subplot(2,1,2)
plot(vetor_frequencia,fft_sinal2)
title("FFT do sinal 2 eixo X")
xlabel("Frequência [Hz]")
ylabel("Aceleração*Fs [m/s^2]")

/*Se trata de um sistema ergódico, sem frequências naturais definidas*/

//######## Capítulo 3: Sinal com filtro ########

FILTERED1 = zeros(length(fft_sinal1),1)
FILTERED2 = zeros(length(fft_sinal2),1)

Wc = 12; //[Hz]

for K = 2:length(fft_sinal1)
    FILTERED1(K,:) = (1 - Wc * dt)*FILTERED1(K-1,:) + Wc * dt * fft_sinal1(K-1,:);
end

for K = 2:length(fft_sinal2)
    FILTERED2(K,:) = (1 - Wc * dt)*FILTERED2(K-1,:) + Wc * dt * fft_sinal2(K-1,:);
end

//Sinal FILTRADO 1
scf(3)
subplot(2,1,1)
plot(vetor_frequencia,fft_sinal1,"r")
plot(vetor_frequencia,FILTERED1,"b")
legend(["FFT Sinal 1", "FFT Sinal 1 filtrado"])
title("Sinal Filtrado 1 eixo X")
xlabel("Frequência [Hz]")
ylabel("Aceleração*Fs [m/s^2]")



//Sinal FILTRADO 2
subplot(2,1,2)
plot(vetor_frequencia,fft_sinal1,"r")
plot(vetor_frequencia,FILTERED2,"b")
legend(["FFT Sinal 2", "FFT Sinal 2 filtrado"])
title("Sinal Filtrado 2 eixo X")
xlabel("Frequência [Hz]")
ylabel("Aceleração*Fs [m/s^2]")

//######## Capítulo 4: Resultados ########
/*Ao aplicar o filtro do sinal o que se observa é que há uma atenuação
das frequências mais baixas, ou seja, quando um carro passa por um 
buraco, temos esse efeito atenuado. Isso permite avaliar o conforto e
o limite de exposição de um ser humano dentro do veículo segundo a norma
ISO2361, com isso, é possível validar se o carro está ou não com sua
suspensão apropriada.

Para uma exposição de 4h dentro do veículo (supondo uma condição de
viagem na estrada dentro do Estado de São Paulo) o carro é de fato
agradavel, pois apresenta aceleração menor de 2 m/s^2 com o sinal
filtrado. Porém, sem filtro (passando por buracos) o limite de exposição
é antingido.

Para viagens de até 1h (supondo um percurso de casa até a USP), o limite
de exposição não é atingido em um percurso sem buracos. Outro ponto a
se considerar é que o limite de exposição é menor em frequências entre
4 Hz e 8 Hz sendo considerado a faixa crítica.

Com isso, respondendo a pergunta inicial se a suspensão do veículo
funciona adequadamente, podemos afirmar com base no experimento e na
norma que o veículo está abaixo do limite de exposição máximo para 
estradas minimamente sem buracos e percursos de até 4h. Para estradas
esburacdas, o tempo de exposição máximo é de aproximadamente 25 minutos.
Por fim, também é possível afirmar que o veículo apresenta baixo
conforto.*/

//######## Bibliografia ########

/*
[1] TAMAI, E; TRIGO, F. Apostilas e notas de aula da disciplina PME3402
Oferecida ao curso de Engenharia Mecânica da Escola Politécnica da
Universidade de São Paulo. São Paulo, 2021.

[2] Norma ISO 2631. Guia Para Avaliação da exposição humana à vibrações
de corpo Inteiro. (1978).
*/
