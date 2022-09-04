%PME 3481 - Controle e Aplicações
%Código para o TRec


%Limpando vars e console
clear;clc;

%Definindo os parâmetros de interesse do modelo

%Parâmetros do robô
M1 = 3.294; %em Kg
J1 = 0.0633; %em Kg.m²
r = 0.226; %em m 

%Parâmetros da massa pontual
M2 = 1.795; %em Kg
J2 = 0.007428; %em Kg.m²
e = 0.065; %em m 

%Parâmetros do motor de corrente contínua
Kt = 0.00852; %em N.m/A
Ke = 0.00638; %em V.s/rad
R = 0.324; %em ohm

Tv = 0.01; %em N.m/s
V = 1; %em Volts
g = 9.81; %em m/s²

X1 = J1+J2+M1*r*r+M2*r*r+M2*e*e-2*M2*r*e;
X2 = J2-M2*r*e+M2*e*e;
X3 = J2+M2*e*e;
Y1 = (X3/(X2*X2-X1*X3));
Y2 = (X2/(X2*X2-X1*X3));

%Definindo as matrizes do espaço de estado do sistema

%Definindo a matriz A

A = [0, 1 , 0 , 0;
    Y1*M2*g*e*(X3/X2-1), -X3*Y1*Tv/X2, Y1*M2*g*e*(X3/X2-1), (Y1*Kt*Ke/R)*(X3/X2-1);
     0, 0, 0, 1;
     Y2*M2*g*e*(X1/X2-1), Y2*Tv,  Y2*M2*g*e*(X1/X2-1), (Y2*Kt*Ke/R)*(1+X1/X2)];

%Definindo a matriz B

B = [0; (Y1*Kt/R)*(1+X3/X2);0; -(Y2*Kt/R)];

%Definindo a matriz C

C=[r 0 0 0;
   0 r 0 0];

%Definindo a matriz D

D=[0;0];

%Espaço de estados
sys = ss(A,B,C,D);

%Obtendo FTs
C1=[r 0 0 0];
C2=[0 r 0 0];
D1=[0];

%FT da posição do robô G1=F(x1/V)
G1 = tf(ss(A,B,C1,D1));

%FT da velocidade do robô G2=F(x_ponto1/V)
G2 = tf(ss(A,B,C2,D1));

H = 1;

%Resposta ao degrau para G2 por ITAE

Kitae = pid(351,16.5);

Titae = feedback(Kitae*G2,H);

%Vetor de tempo

t=0:0.1:10;

yitae = step(feedback(Kitae*G2,H),t);

figure(1)

plot(t,yitae)
title('Resposta ao degrau por ITAE')
xlabel('Tempo [s]')
ylabel('Velocidade do robô esférico [m/s]')
grid on

%Redução de ordem do sistema pela norma de Hankel

zpkG2 = zpk(ss(A,B,C2,D1));

[sysb,g1] = balreal(zpkG2);

g1'

sysr = modred(sysb,[1],'del');

zpkG2r = zpk(sysr);

figure(2)

bode(zpkG2,'-',zpkG2r,'r*')
grid on