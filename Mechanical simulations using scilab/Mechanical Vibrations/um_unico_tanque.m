clear all
close all
clc

%% Simulando
A=73.8*10^-4; %[m^2]

dt = 0.01
t0 = 0
tf = 48
t = t0:dt:tf;

y0=[0.15];
[t,y]=ode45(@sistema,t,y0);

plot(t,y(:,1)*100)
% raiz da cora precisa dar uma reta
grid on
xlabel("Tempo [s]")
ylabel("h [cm]")
title("Tanque esvaziando com vazão zero")

%% PID
di=7*10^-3; %[m]
Ao=(pi*di^2)/4; %[m^2]
A=73.8*10^-4; %[m^2]
cd=0.72;
g=9.8; %[m/s^2]
h0=33*10^-3 %[m]

A_matriz=[-cd*Ao*g/(A*(2*g*h0)^0.5)]
B_matriz=[1/A]
C_matriz=[1]
D_matriz=[0]

sys=ss(A_matriz,B_matriz,C_matriz,D_matriz)
C_PID = pidtune(sys,'PI')
sys1 = feedback(sys*C_PID,1);
opt = stepDataOptions('InputOffset',0,'StepAmplitude',0.1);
step(sys1,opt)
xlabel("Tempo [s]")
ylabel("cota do tanque [m]")
grid on
title("Resposta a impulso")

%% sistema
function dy = sistema(t,y)
di=7*10^-3; %[m]
Ao=(pi*di^2)/4; %[m^2]
A=73.8*10^-4; %[m^2]
cd=0.72;
cv=cd*Ao
g=9.8; %[m/s^2]

Qe=0; %[m^3/s]

dy(1)=(1/A)*(Qe-cv*(2*g*y(1))^(1/2));

dy=dy';
end