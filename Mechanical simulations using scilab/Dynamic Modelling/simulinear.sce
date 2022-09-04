// Simulacao de sistema linear
// Eh sempre melhor apagar as variaveis anteriores
clear
// Definir parametros:
S=10; // [m^2] Area da secao transversal do reservatorio
rho=1000; // [kg/m^3] massa especifica da agua
g=9.8; // [m/s^2] aceleração da gravidade na superficie da Terra
R=2*10^8; // [Pa/(m^3/s)^2] parametro que relaciona pressao e vazao
ho=2; // [m] nivel do reservatorio em regime
hi=0.1; // [m] nivel adicional desejado
Qei=(1/2)*sqrt(rho*g/(R*ho))*hi; // [m^3/s] vazao na entrada
// Definir o sistema linear usando o comando syslin:
A=(-1/(2*S))*sqrt(rho*g/(R*ho));
B=1/S;
C=1;
D=0;
tanque=syslin('c',A,B,C,D); // o parametro 'c' indica que o sistema eh
// continuo no tempo
// Definir a condicao inicial:
x0=0; // [m] desvio inicial do nivel em relação ao equilibrio
// Definir o vetor de instantes de tempo:
t=0:10:40000;
// Definir o vetor de entradas:
u=Qei*ones(t);
// Simulando o sistema usando o comando csim:
[y,x]=csim(u,t,tanque,x0);

//Simulando sistema não linear

function hdot = tanque2(t,h) //Tanque não linear
    hdot = (-sqrt(rho*g*h/R))/S; //Quase ctz que essa equação ta errada
endfunction
t2=0:1:40000;
h = ode(0,0,t2,tanque2); // h eh o nivel do reservatorio [m]

// Plotando o resultado em verde:
plot2d(t,y,3)
plot2d(t2,h,5)

// Colocando um titulo na figura e nomeando os eixos:
xtitle("Resposta do tanque","Tempo t [s]","Variacao de nivel [m]");
// Colocando uma grade azul no grafico:
xgrid(2)
