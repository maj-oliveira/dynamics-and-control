pkg load control

clear; clc;
%FUNÇÃO DE TRANSFERÊNCIA
p1=1;p2=0.5;
s = tf('s');
GH = (1)/(s*(s+p1)*(s+p2));
T=GH/(1+GH);
[re,im,w]=nyquist(GH);
figure(1)
hold on
nyquist(GH)
axis ([-2, 2, -2, 2], "square");
title("Digrama de Nyquist p1=1 e p2=0.5")
t = linspace(0,2*pi,100)'; 
circsx = cos(t); 
circsy = sin(t); 
plot(circsx,circsy,'r');
hold off

figure(2)
bode(GH)
[gamma, phi, w_gamma, w_phi] = margin (GH);
figure(3)
margin(GH)

angle(GH(0.86))