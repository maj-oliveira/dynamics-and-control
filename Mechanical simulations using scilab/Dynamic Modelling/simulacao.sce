clear  // apaga as variaveis anteriores

//Parametros:

Qe=0.010247;
S1 = 10; // [m^2] Area da secao transversal do reservatorio 1
S2 = 8; // [m^2] Area da secao transversal do reservatorio 2
rho = 1000; // [kg/m^3] massa especifica da agua
g = 10; // [m/s^2] aceleração da gravidade na superficie da Terra
Ra = 2*10^8; //[Pa/(m^3/s)^2] parametro que relaciona pressao e vazao
Rs = 2*10^8; // [Pa/(m^3/s)^2] parametro que relaciona pressao e vazao
ho = 2; // [m] nivel do reservatorio em regime
hi = 0.1; // [m] nível adicional desejado

Qei = sqrt(rho*g*(ho+hi)/Ra); // [m^3/s] vazao na entrada

// Definir condicoes iniciais:
h0=[2;0];
//h10 = 2;
//h20 = 0;

// Definir o vetor t de instantes de tempo:
t = 0:10:40000; // vetor de tempo.

exec("reservatorio.sci");

// Comando que realiza a simulacao numérica:
[h] = ode(h0,t(1),t,tanque); // h eh o nivel do reservatorio [m]
// Plotando o resultado em verde:
plot2d(t,h(1,:),5)
plot2d(t,h(2,:),2)
// Definindo uma variavel do tipo 'lista':
T = list("Resposta transitoria do reservatorio","Tempo t [s]","Nivel h [m]");
// Colocando um titulo na figura e nomeando os eixos:
xtitle(T(1),T(2),T(3));
// Colocando legenda no gráfico
legends(["Altura do reservatório 1","Altura do reservatório 2"],[5,2],4)
// Colocando uma grade azul no grafico:
xgrid(2)
