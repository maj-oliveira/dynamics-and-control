clear; clc;
%FUNÇÃO DE TRANSFERÊNCIA

K=30
s = tf('s');
GH = K*(s+1)/(s^4+3*s^3+12*s^2-16*s)
T=GH/(1+GH)

%figure(1)
%margin(GH);
%figure(2)
%nyquist(GH)
%figure(3);
%step(T);

%compensador de avanço
mfa = 30*2*pi/360;
alpha=(1+sin(mfa))/(1-sin(mfa))

wm=10.5
z=sqrt(wm*wm/alpha)
p=alpha*z

Gc=alpha*(s+z)/(s+p);
GH2=Gc*GH;
T2=GH2/(1+GH2);
%nyquist(GH2)
%figure(4)
%margin(GH2)
%figure(5)
%step(T2)
%figure(8)
%nyquist(T2)

%compensador lugar das raízes
%rlocus(T)
z=3.16
p=33.68
Gc=(s+z)/(s+p);
Gaux=1/(GH*Gc);
Kc=64.52
Gc=Gc*Kc
GH3=GH*Gc
%nyquist(GH3)
T3=(GH3)/(1+GH3)
%figure(6)
%step(T3)
figure(7)
margin(GH3)

%ITAE
Gc=optimPID(GH2,3,4);   % PID-Control, ITAE index
T4=(GH2*Gc)/(1+GH2*Gc)
GH4=GH2*Gc
%figure(1)
%step(T4)
%title("PID Otimizado por ITAE")

%TODAS AS RESPOSTAS
%figure (1)
hold on
t=25
%step(T,t)
%step(T2,t)
%step(T3,t)
%step(T4,t)
%step(T5,t)
%legend('Não compensado', 'compensador de avanço','PID ITAE','PID LR')
hold off

%Lugar das raízes para o sistema de melhor desempenho
%figure(1)
%rlocus(GH4)
%title("LR PID ITAE")

%figure(2)
%margin(GH4)

figure(3)
[re,im]=nyquist(GH4);
re=squeeze(re)
im=squeeze(im)
plot(re,im)

figure(4)
nyquist(GH4)