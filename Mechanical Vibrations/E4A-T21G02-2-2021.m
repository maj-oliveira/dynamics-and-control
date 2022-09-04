clc
clear
close all

%% Dados do esquema:

h= 24*10^-3 %m distância entre o centro do celular e do cilindro
l_cel=67.5*10^-3 % largura x em metros
c_cel=141.7*10^-3 % comprimento y em metros
t_cel=8.6*10^-3 % espessura em metros
d_lata = 100 *10^-3 %m diâmetro da lata
l_lata = 104*10^-3 %m altura da lata
h_lata = 15*10^-3 %m
R=d_lata/2
m_cel=150*10^-3 %kg massa do celular
m_lata=61*10^-3 %kg massa da lata
g=9.81 %m/s^2
m_apoio= 29*10^-3 %kg massa do apoio
M=m_cel+m_lata+m_apoio %kg massa do conjunto

%% find Fs
Ts=0.01; %seconds
Fs=1/Ts; %Hz

%% ----------------Medições Cilindro Desbalanceado----------------
%% Questão 1
%M.I. -> momento de inércia
J_cel = m_cel*(l_cel^2+t_cel^2)/12+m_cel*h^2 %M.I em relação ao centro do cilindro
m_parede = m_lata*pi*d_lata*l_lata/(pi*d_lata*l_lata + pi*d_lata^2/4)
m_fundo = m_lata - m_parede
e = (m_lata*0+0*m_apoio+m_cel*h)/M % m excentricidade
%M.I. em relação ao Centro do Cilindro
J_lata = m_lata*R^2
J_O=J_lata+J_cel
J_G = J_O - M*e^2 %M.I. no CM do sólido

%% Questão 3
alpha = 10*pi/180 %rad - ângulo de inclinação
theta_0 = asin(R*sin(alpha)/e)*180/pi %º posição de equilíbrio 

%% Questão 4
%determinada experimentalmente
alpha = 18*pi/180 %rad - ângulo limite da existência de eq. estável
angulo_limite = 30*pi/180 %rad - ângulo limite de escorregamento
u_esc = tan(angulo_limite) %cálculo do coeficiente de atrito de escorregamento

%% Questão 6
T1=readtable("6) Medida1.xls");
T2=readtable("6) Medida2.xls");

T1 = T1{100:1000,:};
T2 = T2{100:1000,:};
n=length(T1(:,1));

plot(T1(:,1),T1(:,2),'linewidth',2)
grid on
xlabel('Tempo [s]')
ylabel('Aceleração [m/s^2]')
title('Variação da aceleração X no tempo')
legend('X')
figure()

plot(T1(:,1),T1(:,4),'-r','linewidth',2)
grid on
xlabel('Tempo [s]')
ylabel('Aceleração [m/s^2]')
title('Variação da aceleração Z no tempo')
legend('Z')
figure()
%% Questão 7
%Integrando numericamente a equação diferencial

t0=1
t1=10
theta0=theta_0*pi/180
theta1=1
h=0.01
                                             % step size
x = 0:h:10;                                         % Calculates upto y(3)
y = zeros(1,length(x)); 
y(1) = 5;                                          % initial condition
F_xy = @(t,r) 3.*exp(-t)-0.4*r;                    % change the function as you desire

for i=1:(length(x)-1)                              % calculation loop
    k_1 = F_xy(x(i),y(i));
    k_2 = F_xy(x(i)+0.5*h,y(i)+0.5*h*k_1);
    k_3 = F_xy((x(i)+0.5*h),(y(i)+0.5*h*k_2));
    k_4 = F_xy((x(i)+h),(y(i)+k_3*h));

    y(i+1) = y(i) + (1/6)*(k_1+2*k_2+2*k_3+k_4)*h;  % main equation
end

%Gráficos theta e dtheta/dt



%% Questão 8

T3=readtable("8) 1volta.xls");
T4=readtable("8) 2voltas.xls");

T3 = T3{100:1000,:};
T4 = T4{100:1000,:};
n=length(T1(:,1));


plot(T3(:,1),T3(:,2),'linewidth',2)
grid on
xlabel('Tempo [s]')
ylabel('Aceleração [m/s^2]')
title('Variação da aceleração X no tempo')
legend('X')
figure()

plot(T3(:,1),T3(:,4),'-r','linewidth',2)
grid on
xlabel('Tempo [s]')
ylabel('Aceleração [m/s^2]')
title('Variação da aceleração Z no tempo')
legend('Z')

