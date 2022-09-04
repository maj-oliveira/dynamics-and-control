%PME 3481 - Controle e Aplica��es
%C�digo para o T1

%Definindo os par�metros de interesse do modelo

%Par�metros do rob�
M1 = 3.294; %em Kg
J1 = 0.0633; %em Kg.m�
r = 0.226; %em m 

%Par�metros da massa pontual
M2 = 1.795; %em Kg
J2 = 0.007428; %em Kg.m�
e = 0.065; %em m 

%Par�metros do motor de corrente cont�nua
Kt = 0.00852; %em N.m/A
Ke = 0.00638; %em V.s/rad
R = 0.324; %em ohm

Tv = 0.01; %em N.m/s
V = -5; %em Volts
g = 9.81; %em m/s�

X1 = J1+J2+M1*r*r+M2*r*r+M2*e*e-2*M2*r*e;
X2 = J2-M2*r*e+M2*e*e;
X3 = J2+M2*e*e;
Y = (X2/(X2*X2-X1*X3));

%Definindo as matrizes do espa�o de estado do sistema

%Definindo a matriz A

A = [0, 1 , 0 , 0;
    Y*M2*g*e*(X3/X2-1), -X3*Y*Tv/X2, Y*M2*g*e*(X3/X2-1), (Y*Kt*Ke/R)*(X3/X2-1);
     0, 0, 0, 1;
     Y*M2*g*e*(X1/X2-1), Y*Tv,  Y*M2*g*e*(X1/X2-1), (Y*Kt*Ke/R)*(1+X1/X2)];

%Definindo a matriz B

B = [0; (Y*Kt/R)*(1+X3/X2);0; -(Y*Kt/R)];

%Definindo a matriz C

C = [0,0,1,0];

%Definindo a matriz D

% = zeros(1,1);

%Checando a controlabilidade a partir do vetor coluna B escolhido

%Vetor coluna B escolhido
B = [0; (Y*Kt/R)*(1+X3/X2);0; -(Y*Kt/R)];

%Checando a controlabilidade

CTRL = horzcat(B,A*B,(A^2)*B,(A^3)*B);
if rank (CTRL) == 4
  disp('Control�vel')
else
  disp('N�o Control�vel')
end

%Checando a observabilidade a partir do vetor linha C escolhido

%Vetor linha C escolhido
C = [0,0,1,0];

%Checando a observabilidade
OBS = horzcat(transpose(C),(transpose(A)*transpose(C)),(transpose(A^2)*transpose(C)),(transpose(A^3)*transpose(C)));
if rank (OBS) == 4
  disp('Observ�vel')
else
  disp('N�o Observ�vel')
end

%Controle por aloca��o de p�los

%4 p�los que devem ser alocados

v = [ -0.50000 - 10.00000i, -0.50000 + 10.00000i,-1.00000 - 1.00000i,-1.00000 + 1.00000i];

%O vetor de ganhos de controle �, portanto,

kaloc = place(A,B,v);

%Simula��o por aloca��o de p�los
dt = 0.1;
t = 0:dt:10;
a = size(t);
n = a(2);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condi��es iniciais
X(1,1) = 0;
X(2,1) = 5;
X(3,1) = 0;
X(4,1) = 0;

%Matriz de transi��o
F = A - B*kaloc;
mt = expm(F*dt);

for i = 1:n-1
  X(:,i+1) = mt*X(:,i);
end

%figure(1)
%plot(t,(r*X(1,:)),'r')
%hold on
%plot(t,(r*X(2,:)),'g')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
%title("Controle por aloca��o de p�los")

%figure(2)
%plot(t,X(3,:),'b')
%hold on
%plot(t,X(4,:),'y')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
%title("Controle por aloca��o de p�los")


%Controle pelo LQR (Linear Quadratic Regulator)

%A busca por melhores valores de P e Q levou �s seguintes matrizes
Q = [5,0,0,0;0,5,0,0;0,0,5,0;0,0,0,5];
P = [0.01];

%O vetor de ganhos de controle �, portanto,
klqr = lqr(A,B,Q,P);

%Simula��o pelo LQR (Linear Quadratic Regulator)
dt = 0.1;
t = 0:dt:10;
a = size(t);
n = a(2);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condi��es iniciais
X(1,1) = 0;
X(2,1) = 10;
X(3,1) = 0;
X(4,1) = 0;

%Matriz de transi��o
F = A - B*klqr;
mt = expm(F*dt);

for i = 1:n-1
  X(:,i+1) = mt*X(:,i);
end

%figure(3)
%plot(t,(r*X(1,:)),'r')
%hold on
%plot(t,(r*X(2,:)),'g')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
%title("Controle linear quadr�tico")

%figure(4)
%plot(t,X(3,:),'b')
%hold on
%plot(t,X(4,:),'y')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
%title("Controle linear quadr�tico")

%Observadores de estado por aloca��o de p�los

%4 p�los que devem ser alocados

vo = [-1.00000 - 10.00000i, -1.00000 + 10.00000i,-2.00000 - 1.00000i,-2.00000 + 1.00000i];

%O vetor de ganhos de ganhos de observa��o �, portanto,

koaloc = place(transpose(A),transpose(C),vo);

%Simula��o pelo observador de estados por aloca��o de p�los
dt = 0.1;
t = 0:dt:10;
a = size(t);
n = a(2);
E = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condi��es iniciais
E(1,1) = 0;
E(2,1) = 10;
E(3,1) = 0;
E(4,1) = 0;

%Matriz de transi��o
F = A - ((transpose(koaloc))*C);
mt = expm(F*dt);

for i = 1:n-1
  E(:,i+1) = mt*E(:,i);
end

%figure(5)
%plot(t,(r*E(1,:)),'r')
%hold on
%plot(t,(r*E(2,:)),'g')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
%title("Observador de estados por aloca��o")

%figure(6)
%plot(t,E(3,:),'b')
%hold on
%plot(t,E(4,:),'y')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
%title("Observador de estados por aloca��o")

%Observadores de estado por LQR

%A busca por melhores valores de Po e Qo levou �s seguintes matrizes
Qo = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
Po = [1];

%O vetor de ganhos de ganhos de observa��o �, portanto,

kolqr = lqr(transpose(A),transpose(C),Qo,Po)

%Simula��o pelo observador de estados por aloca��o de p�los
dt = 0.1;
t = 0:dt:10;
a = size(t);
n = a(2);
E = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condi��es iniciais
E(1,1) = 0;
E(2,1) = 10;
E(3,1) = 0;
E(4,1) = 0;

%Matriz de transi��o
F = A - ((transpose(kolqr))*C);
mt = expm(F*dt)

for i = 1:n-1
  E(:,i+1) = mt*E(:,i);
end

%figure(7)
%plot(t,(r*E(1,:)),'r')
%hold on
%plot(t,(r*E(2,:)),'g')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
%title("Observador de estados por LQ")

%figure(8)
%plot(t,E(3,:),'b')
%hold on
%plot(t,E(4,:),'y')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
%title("Observador de estados por LQ")

%Princ�pio de Separa��o

%Construindo a matriz S, para o regulador e observador por aloca��o de p�los

S11 = A-B*kaloc;
S12 = B*kaloc;
S21 = zeros(4,4);
S22 = A - ((transpose(koaloc))*C);

S = [S11,S12;S21,S22];

%C�lculo dos polos da matriz S 
eig(S);

%C�lculo dos polos do controlador 
eig(A-B*kaloc);

%C�lculo dos polos do observador
eig(A-(transpose(koaloc))*C);

%Simula��o da matriz S
dt = 0.1;
mtCO = expm(S*dt);
t = 0:dt:10;
a = size(t);
n = a(2);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condi��es iniciais
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

figure(9)
plot(t,(r*X(1,:)),'r')
hold on
plot(t,(r*X(2,:)),'g')
hold off
grid on
xlabel("Tempo [s]")
legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
title("Simula��o com a matriz S para o controlador")

figure(10)
plot(t,X(3,:),'b')
hold on
plot(t,X(4,:),'y')
hold off
grid on
xlabel("Tempo [s]")
legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
title("Simula��o com a matriz S para o controlador")

figure(11)
plot(t,(r*X(5,:)),'r')
hold on
plot(t,(r*X(6,:)),'g')
hold off
grid on
xlabel("Tempo [s]")
legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
title("Simula��o com a matriz S para o observador")


figure(12)
plot(t,X(7,:),'b')
hold on
plot(t,X(8,:),'y')
hold off
grid on
xlabel("Tempo [s]")
legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
title("Simula��o com a matriz S para o observador")

%Construindo a matriz S, para o regulador e observador por LQ

Slq11 = A-B*klqr;
Slq12 = B*klqr;
Slq21 = zeros(4,4);
Slq22 = A - ((transpose(kolqr))*C);

Slq = [Slq11,Slq12;Slq21,Slq22];

%C�lculo dos polos da matriz Slq
eig(S);

%C�lculo dos polos do controlador por LQ
eig(A-B*klqr);

%C�lculo dos polos do observador por LQ
eig(A-(transpose(kolqr))*C);

%Simula��o da matriz S
dt = 0.1;
mtCOlq = expm(Slq*dt);
t = 0:dt:10;
a = size(t);
n = a(2);
X = [zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n);zeros(1,n)];

%Condi��es iniciais
X(1,1) = 0;
X(2,1) = 10;
X(3,1) = 0;
X(4,1) = 0;
X(5,1) = 0;
X(6,1) = 10;
X(7,1) = 0;
X(8,1) = 0;

for i = 1:n-1
  X(:,i+1) = mtCOlq*X(:,i);
end

%figure(13)
%plot(t,(r*X(1,:)),'r')
%hold on
%plot(t,(r*X(2,:)),'g')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
%title("Simula��o com a matriz Slq para o controlador")

%figure(14)
%plot(t,X(3,:),'b')
%hold on
%plot(t,X(4,:),'y')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
%title("Simula��o com a matriz Slq para o controlador")

%figure(15)
%plot(t,(r*X(5,:)),'r')
%hold on
%plot(t,(r*X(6,:)),'g')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o do rob� [m]", "Velocidade do rob� [m/s]")
%title("Simula��o com a matriz Slq para o observador")

%figure(16)
%plot(t,X(7,:),'b')
%hold on
%plot(t,X(8,:),'y')
%hold off
%grid on
%xlabel("Tempo [s]")
%legend("Posi��o angular da massa pontual [rad]","Velocidade angular da massa pontual [rad/s]")
%title("Simula��o com a matriz Slq para o observador")

