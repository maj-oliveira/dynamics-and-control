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
V = 5; %em Volts
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
G1 = tf(ss(A,B,C1,D1))

%FT da velocidade do robô G2=F(x_ponto1/V)
G2 = tf(ss(A,B,C2,D1))

%SEGUIDOR
v = [ -0.5 - 10i, -0.5 + 10i,-1 - 1i,-1 + 1i];
aux=[A B; C D];
A1=pinv(aux);
K=place(A,B,v);
F=A-B*K;
No=[0 0 0 0 1 1]';
Nxu=A1*No;
Nx=Nxu(1:4);
Nu=Nxu(5);
urp=Nu+K*Nx;
B1=[0;0;0;urp];
sysSeguidor = ss(F,B1,C,D);
%figure(1)
%step(sysSeguidor)
%grid on
%title("Seguidor de referência")
%xlabel("Tempo [s]")
%ylabel("Velocidade")

%SIMULAÇÃO ENTRADA CONSTANTE

t = [0:0.1:60];
x0=[0;0;pi/4;0];
x=zeros(4,length(t));
x(:,1)=x0;

u=ones(length(t),1)*V;

[y, t, x] = lsim (sys, u, t, x0);

%figure (2);
%plot(t,transpose(y(:,2)),'r')
%grid on
%title('Simulacao entrada constante')
%xlabel('tempo [s]')
%ylabel('Velocidade do robô esférico [m/s]')

%SIMULAÇÃO ENTRADA DEGRAU
u1=zeros(200,1);
u2=ones(length(t)-200,1)*V;
u=vertcat(u1,u2);
[y, t, x] = lsim (sys, u, t, x0);


%figure (3);
%plot(t,transpose(y(:,1)),'b')
%grid on
%title('Simulacao entrada degrau')
%xlabel('tempo [s]')
%ylabel('Posição do robô esférico [m/s]')

%RESPOSTA EM FREQUÊNCIA
T1=G1/(1+G1);
T2=G2/(1+G2);
w=0.01:0.01:100;
% figure(4)
% bode(T2,w)
% grid on
% title("Diagrama de Bode de T2")

%ESTABILIDADE
pole(sys);
zero(sys);

format long
Polos=eig(A)
format short

%figure (5);
%plot(real(Polos),imag(Polos),'ro')
%title('Polos no plano complexo')
%xlabel('Eixo Real')
%ylabel('Eixo Imaginário')
%grid on
%[1 0.0588 72.14 3.648 -2.192*10^-13]
%rhStabilityCriterion()

%PID POR ALOCAÇÃO DE POLOS
s = tf('s');
Gc=104.4092+12.3136/s;
T2=G2*Gc/(1+G2*Gc);
%figure(6)
%step(T2)
%xlabel("Tempo [s]")
%grid on
%ylabel('Velocidade do robô esférico [m/s]')

%PID ITAE
Kp=100;
Ki=5;
Kd=0;
i=0;
t=0:0.01:60;
dt=0.01;
%Instruções:
%Para encontrar Kp, Kd e Ki, alterar valor do K no for
%Vai aparecer o gráfico de JxK, selecionar K que tenha
%J mínimo. Então substituir K acima.
 %for Kd=0:1:100
%     i=i+1
%     Gc=Kp+Ki/s+Kd*s;
%     T2=G2*Gc/(1+G2*Gc);
%     erro=1-step(T2,t);
%     J(i)=sum(t'.*abs(erro)*dt);
% end
 k=0:1:100;
 %figure(10)
 %plot(k,J)
 
Kp=100;
Ki=5;
Kd=0;
Gc=Kp+Ki/s+Kd*s;
T2=G2*Gc/(1+G2*Gc);
%figure(7)
%step(T2)
%xlabel("Tempo")
%title("Resposta Degrau PID otimizado por ITAE")
%ylabel('Velocidade do robô esférico [m/s]')
%grid on

%ANÁLISE DE CONTROLABILIDADE
CTRL = horzcat(B,A*B,(A^2)*B,(A^3)*B);
%disp(rank(CTRL));

%ANÁLISE DE OBSERVABILIDADE
OBS = horzcat(transpose(C),(transpose(A)*transpose(C)),(transpose(A^2)*transpose(C)),(transpose(A^3)*transpose(C)));
%disp(rank(OBS));

%CONTROLE POR ALOCAÇÃO DE POLOS

v = [ -0.50000 - 10.00000i, -0.50000 + 10.00000i,-1.00000 - 1.00000i,-1.00000 + 1.00000i];

dt = 0.1;
t = 0:dt:10;
a = size(t);
n = a(2);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

kaloc = place(A,B,v);
F = A - B*kaloc;
mt = expm(F*dt);
X(1,1) = 0;
X(2,1) = 5;
X(3,1) = 0;
X(4,1) = 0;

for i = 1:n-1
  X(:,i+1) = mt*X(:,i);
end

% figure(1)
% plot(t,(r*X(1,:)),'r')
% hold on
% plot(t,(r*X(2,:)),'g')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição do robô [m]", "Velocidade do robô [m/s]")
% title("Controle por alocação de pólos")
% 
% figure(2)
% plot(t,X(3,:),'b')
% hold on
% plot(t,X(4,:),'y')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
% title("Controle por alocação de pólos")

%CONTROLE LQR
Q = [5,0,0,0;0,5,0,0;0,0,5,0;0,0,0,5];
P = [0.01];
klqr = lqr(A,B,Q,P);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];
X(1,1) = 0;
X(2,1) = 5;
X(3,1) = 0;
X(4,1) = 0;

F = A - B*klqr;
eig(F);
mt = expm(F*dt);

for i = 1:n-1
  X(:,i+1) = mt*X(:,i);
end

% figure(3)
% plot(t,(r*X(1,:)),'r')
% hold on
% plot(t,(r*X(2,:)),'g')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição do robô [m]", "Velocidade do robô [m/s]")
% title("Controle linear quadrático")
% 
% figure(4)
% plot(t,X(3,:),'b')
% hold on
% plot(t,X(4,:),'y')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
% title("Controle linear quadrático")

%OBSERVADOR DE ESTADOS
vo = [-1.00000 - 10.00000i, -1.00000 + 10.00000i,-2.00000 - 1.00000i,-2.00000 + 1.00000i];
koaloc = place(transpose(A),transpose(C),vo);
dt = 0.1;
t = 0:dt:10;
a = size(t);
n = a(2);
E = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];
E(1,1) = 0;
E(2,1) = 5;
E(3,1) = 0;
E(4,1) = 0;

F = A - ((transpose(koaloc))*C);
mt = expm(F*dt)

for i = 1:n-1
  E(:,i+1) = mt*E(:,i);
end

% figure(5)
% plot(t,(r*E(1,:)),'r')
% hold on
% plot(t,(r*E(2,:)),'g')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição do robô [m]", "Velocidade do robô [m/s]")
% title("Observador de estados por alocação")
% 
% figure(6)
% plot(t,E(3,:),'b')
% hold on
% plot(t,E(4,:),'y')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
% title("Observador de estados por alocação")

Qo = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
Po = [1];
kolqr = lqr(transpose(A),transpose(C),Qo,Po);
dt = 0.1;
t = 0:dt:20;
a = size(t);
n = a(2);
E = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];
E(1,1) = 0;
E(2,1) = 5;
E(3,1) = 0;
E(4,1) = 0;

F = A - ((transpose(kolqr))*C);
mt = expm(F*dt)

for i = 1:n-1
  E(:,i+1) = mt*E(:,i);
end

% figure(7)
% plot(t,(r*E(1,:)),'r')
% hold on
% plot(t,(r*E(2,:)),'g')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição do robô [m]", "Velocidade do robô [m/s]")
% title("Observador de estados por LQ")
% 
% figure(8)
% plot(t,E(3,:),'b')
% hold on
% plot(t,E(4,:),'y')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
% title("Observador de estados por LQ")

%PRINCIPIO DA SEPRAÇÃO
S11 = A-B*kaloc;
S12 = B*kaloc;
S21 = zeros(4,4);
S22 = A - ((transpose(koaloc))*C);

S = [S11,S12;S21,S22];

%Cálculo dos polos da matriz S 
eig(S);

%Cálculo dos polos do controlador 
eig(A-B*kaloc);

%Cálculo dos polos do observador
eig(A-(transpose(koaloc))*C);

%Simulação da matriz S
dt = 0.1;
mtCO = expm(S*dt);
t = 0:dt:10;
a = size(t);
n = a(2);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condições iniciais
X(1,1) = 0;
X(2,1) = 10;
X(3,1) = 0;
X(4,1) = 0;
X(5,1) = 0;
X(6,1) = 10;
X(7,1) = 0;
X(8,1) = 0;

for i = 1:n-1
  X(:,i+1) = mtCO*X(:,i);
end

% figure(13)
% plot(t,(r*X(1,:)),'r')
% hold on
% plot(t,(r*X(2,:)),'g')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição do robô [m]", "Velocidade do robô [m/s]")
% title("Simulação com a matriz Slq para o controlador")
% 
% figure(14)
% plot(t,X(3,:),'b')
% hold on
% plot(t,X(4,:),'y')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
% title("Simulação com a matriz Slq para o controlador")

% figure(15)
% plot(t,(r*X(5,:)),'r')
% hold on
% plot(t,(r*X(6,:)),'g')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição do robô [m]", "Velocidade do robô [m/s]")
% title("Simulação com a matriz Slq para o observador")
% 
% figure(16)
% plot(t,X(7,:),'b')
% hold on
% plot(t,X(8,:),'y')
% hold off
% grid on
% xlabel("Tempo [s]")
% legend("Posição angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
% title("Simulação com a matriz Slq para o observador")

%MÉTODO DE ZIEGLER-NICHOLS
% figure (17)
% rlocus(G2)
% grid on
% title("Lugar das raízes para determinar K_{CR}")

%COMPARANDO Kd EM ALOCAÇÃO DE POLOS
% Gc1 = 104.4092+12.3136/s
% Gc2 = 104.4092+12.3136/s+20*s
% Gc3 = 104.4092+12.3136/s+100*s
% Gc4 = 104.4092+12.3136/s+50*s
% Gc5 = 104.4092+12.3136/s+100*s
% 
% T1=G2*Gc1/(1+G2*Gc1)
% T2=G2*Gc2/(1+G2*Gc2)
% T3=G2*Gc3/(1+G2*Gc3)
% T4=G2*Gc4/(1+G2*Gc4)
% T5=G2*Gc5/(1+G2*Gc5)
% 
% figure(18)
% hold on
% step(T1,T2,T3,30)
% legend("Kd=0","Kd=20","Kd=100")
% step(T2)
% step(T3)
% step(T4)
% step(T5)
% hold off
% grid on

% PID por LR

%Um valor ótimo é um valor próximo do eixo imaginário
%Se o ganho for alto demais o sistema é impossível

figure(19)
rlocus(G2)
title("LR de G2 para determinar K_P")
Kp=48.5

G2i = G2/(s*(1+Kp*G2))

figure(20)
rlocus(G2i)
title("LR de G2 para determinar K_I")
Ki=23.4

G2d = s*G2/(Kp*G2+Ki*G2/s+1)

figure(21)
rlocus(G2d)
title("LR de G2 para determinar K_D")
Kd=27

figure(22)
Gc= Kp+Ki/s+Kd*s
T=Gc*G2/(1+Gc*G2)
step(T)
ylabel("Velocidade do robô esférico [m/s]")
title("Resposta em degrau PID por LR")
grid on

% CRITERIO DE ESTABILIDADE POR NYQUIST
Gzn = 3+2.86/s+0.0875*s %Método de Ziegler-Nichols
Gap = 104.4092+12.3136/s %Método por alocação de pólos
Git = 100+5/s % Método por controle ótimo ITAE
Glr = 80.5 + 17/s %Método lor lugar das raízes
% figure(17)
% nyquist(G1*Glr)
% figure(18)
% nyquist(G1*Gzn)