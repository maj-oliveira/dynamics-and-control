clear all
close all
clc

%% Simulando
A=73.8*10^-4; %[m^2]

dt = 0.01
t0 = 0
tf = 20
t = t0:dt:tf;

y0=[0.15;0.15;0.15];
[t,y]=ode45(@sistema,t,y0);

figure(1)
subplot(3,1,1)
plot(t,y(:,1)*100)
title("Cota")
grid on
xlabel("Tempo [s]")
ylabel("h_1 [cm]")

subplot(3,1,2)
plot(t,y(:,2)*100)
grid on
xlabel("Tempo [s]")
ylabel("h_2 [cm]")

subplot(3,1,3)
plot(t,y(:,3)*100)
grid on
xlabel("Tempo [s]")
ylabel("h_3 [cm]")

figure(2)

Q1=A*(y(:,1)-y(:,2))/dt
Q2=A*(y(:,2)-y(:,3))/dt

hold on
plot(t,Q1)
plot(t,Q2)
title("Vazão")
grid on
xlabel("Tempo [s]")
ylabel("Q [m^3/s]")
legend(["Q1","Q2"])

%% PID

di=7*10^-3; %[m]
Ao=(pi*di^2)/4; %[m^2]
A=73.8*10^-4; %[m^2]
cd=0.72;
g=9.8; %[m/s^2]
h01=146*10^-3 %[m]
h02=91*10^-3 %[m]
h03=33*10^-3 %[m]
alpha = (2*g*(h01-h02))^0.5
beta = (2*g*(h02-h03))^0.5
gamma = (2*g*(h03))^0.5

A_matriz = (cd*Ao*g/A)*[-1/alpha 1/alpha 0;
            1/alpha (-1/alpha-1/beta) 1/beta;
            0 1/beta -1/gamma]
B_matriz = [1/A;0;0]

C_matriz = [1 0 0]
        
D_matriz = [0]

step(sys)

sys=ss(A_matriz,B_matriz,C_matriz,D_matriz)
C_PID = pidtune(sys,'PIDF',0.02)
sys1 = feedback(sys*C_PID,1);
opt = stepDataOptions('InputOffset',0,'StepAmplitude',0.1);
step(sys1,opt)
xlabel("Tempo [s]")
ylabel("cota do tanque h3 [m]")
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

dy(1)=(1/A)*(Qe-cv*(2*g*(y(1)-y(2)))^(1/2));
dy(2)=(1/A)*(cv*(2*g*(y(1)-y(2)))^(1/2)-cv*(2*g*(y(2)-y(3)))^(1/2));
dy(3)=(1/A)*(cv*(2*g*(y(2)-y(3)))^(1/2)-cv*(2*g*y(3))^(1/2));

dy=dy';
end