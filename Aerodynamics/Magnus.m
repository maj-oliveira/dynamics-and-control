%##################################################
% Matheus José Oliveira dos Santos
% NUSP: 10335826 - PME3557 - Aerodinâmica 2022
% Cilindro com efeito Magnus e aerofólio de Joukowski
%##################################################

clear all
clc

% parâmetros do aerofólio

a=1.2;
alpha = 10;
beta = -5;

% coordenadas
N = 100;
r = linspace(a-0.001,2,N);
theta = linspace(-pi,pi,N);
[R,T] = meshgrid(r,theta);
Z =  R.*exp(1i*T);

X = real(Z);
Y = imag(Z);

% Velocidade no infinito paralelo ao eixo x
U = 1.0;
sig = 30;

% Circulação (condição de Kutta)
G=4*pi*U*a*sin((alpha-beta)/180*pi);

F_uniform = U*exp(-i*alpha/180*pi)*Z;
F_adicional = U*(a^2*exp(i*alpha/180*pi)./Z);
F_vortex = i*(G/(2*pi))*log(Z/(a*exp(i*alpha/180*pi)));

% Potencial complexo
Ft = F_uniform+F_vortex+F_adicional;

Phi = real(Ft);
Psi = imag(Ft);

% Joukowski
shift=a*exp(i*beta/180.*pi)-1;
z=(Z-shift)+1./(Z-shift);

% Coordenadas reais correspondentes
x=real(z);
y=imag(z);

% Plotagem Magnus
figure(1)
hold on
contour(X,Y,Phi,25,'r--');
contour(X,Y,Psi,floor(min(min(Psi))):.25:ceil(max(max(Psi))),'b-');
axis('square');
grid on
xlabel('x');
ylabel('y');
title("Efeito Magnus")

% Plotagem Joukowski
figure(2)
hold on
contour(x,y,Phi,25,'r--')
contour(x,y,Psi,floor(min(min(Psi))):.25:ceil(max(max(Psi))),'b')
axis('square');
grid on
xlabel('x');
ylabel('y');
title('Joukowski');