pkg load control

clear; clc;
%FUN��O DE TRANSFER�NCIA

K=30
s = tf('s');
GH = K*(s+1)/(s^4+3*s^3+12*s^2-16*s)
T=GH/(1+GH)
hold on
nyquist(1/(1+s))