%##################################################
% Matheus José Oliveira dos Santos
% NUSP: 10335826 - PME3557 - Aerodinâmica 2022
% Oval de Rankine
%##################################################

clc
clear all
close all

%Coordenadas
N = 100;
x = linspace(-4,6,N);
y = linspace(-5,5,N);
[X,Y] = meshgrid(x,y);
Zc = X + 1i*Y;

% cts
Uoo = 1.0;
sig = 30.0;

% Fluxo uniforme em x
F1 = Uoo*Zc;

% Source na origem
F2 = (sig/(2*pi))*log(Zc);

% Sink em Z=2+0*i
F3 = -(sig/(2*pi))*log(Zc-2); 

% Potencial complexo
Ft = F1 + F2 + F3;
Phi = real(Ft);
Psi = imag(Ft);

% Velocidade complexa
W = Uoo + (sig/(2*pi))./Zc -(sig/(2*pi))./(Zc-2);
U = conj(W);
Up = real(U);
Vp = imag(U);

% plot
figure(1),
contour(X,Y,Phi,55,'r--');
hold on
contour(X,Y,Psi,55,'b-');
quiver(X,Y,Up,Vp,5,'g');
grid on
axis('square');
xlabel('x');
ylabel('y');
title('Potencial \Phi, vermelho ; linhas de corrente: \Psi azul');