pkg load control

clear; clc;
%FUNÇÃO DE TRANSFERÊNCIA
s = tf('s');
GH = (1)/(s^2-s)

figure(1)
nyquist(GH)
title("Digrama de Nyquist para o sistema em MA")

T=GH/(1+GH)
P=pole(T)
Z=zero(T)
figure(2)
hold on
nyquist(T)
title("Digrama de Nyquist para o sistema em MF")
plot(P,"rx")
plot(real(Z),imag(Z),"*")

figure(3)
impulse(T,20)
title("Resposta a impulso de T")