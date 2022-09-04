pkg load control

%ex 1
%Definição do sistema
A = [-3 1 0; 2 -3 2; 0 1 -3]
B = [1 0 0;0 1 0;0 0 1]
C = [1 0 0; 0 1 0;0 0 1]
D = [0 0 0;0 0 0;0 0 0]

%Verificando controlabilidade
Mc = [B A*B A*A*B]
rank(Mc)

%Verificando observabilidade
Mo = [transpose(C); transpose(A)*transpose(C) ;
transpose(A)*transpose(A)*transpose(C)]
rank(Mc)

%Alocação de polos controlador
v= [-1+j  -1-j -1.5]
K_p=place(A,B,v)

%Alocação de polos observador
v = [-2.0 - 2.0i , -2.0 + 2.0i , -3]
Ko_p = place(transpose(A),transpose(C),v);
Ko_p=transpose(Ko_p)

%controlador LQ
P=eye(3)
Q=eye(3)
K_lq = lqr(A,B,Q,P)

%Observador LQ
Ko_lq = lqr(transpose(A),transpose(C),Q,P)
Ko_lq = transpose(Ko_lq)

S11 = A-B*K_lq %Controlador
S12 = B*K
S21 = zeros(3,3)
S22 = A-Ko_lq*C %Observador
S=[S11 S12; S21 S22]

%ex 1.1
Polos = eig(S)
Polos_cont = eig(S11)
Polos_obs = eig(S22)

%ex 1.2
matriz_transicao = expm(S*0.1)

%ex 1.3
t = [0:0.1:8];
x0=[10;30;70];
x=zeros(3,length(t));
x(:,1)=x0;
e0=[1;2;3];
e=zeros(3,length(t));
e(:,1)=e0;
v=[x;e];

for k=1:1:length(t)-1
  v(:,k+1)=matriz_transicao*v(:,k);
endfor
v(1:3,50)

figure (1);

plot(t,v(1:3,:))
title('Simulacao 3 tanque')
xlabel('tempo (s)')
ylabel('Altura (m)')

figure (2);

plot(t,v(4:6,:))
title('Simulacao 3 tanque Erro')
xlabel('tempo (s)')
ylabel('Erro')