%##############################################
% Matheus José Oliveira dos Santos
% NUSP: 10335826 - PME3557 - Aerodinâmica 2022
%##############################################

clear
clc

% Velocidade ao longe (m/s)
U=1
% angulo de ataque (graus)
alp=10
% Raio do Cilindro (m)
a=1.2
% Localização do bordo de fuga do cilindro (graus)
beta=-5

% Criação dos pontos da malha ao redor do cilindro no plano zeta
theta = linspace(-pi,pi,100);
r = linspace(a-0.001,2,100);
[csi,rho]=meshgrid(theta,r);
[xi,eta]=pol2cart(csi,rho);
zeta=xi+i*eta;

% Circulação (condição de Kutta)
Gamma=4*pi*U*a*sin((alp-beta)/180*pi)

% Potencial complexo de velocidades nos pontos da malha
F=U*(zeta*exp(-i*alp/180*pi)+a^2*exp(i*alp/180*pi)./zeta)+i*(Gamma/(2*pi))*log(zeta/(a*exp(i*alp/180*pi)));

% Potencial de Velocidades (parte real de F)
phi=real(F);

% Função Corrente (parte imaginária de F)
psi=imag(F);

% Coordenada física mapeada (Joukowski) z = x + i y (plano z)
shift=a*exp(i*beta/180.*pi)-1;
z=(zeta-shift)+1./(zeta-shift);

% Coordenadas reais correspondentes
x=real(z);
y=imag(z);

% Plotagem das Funções Potencial e Corrente no plano zeta
figure(1)
contour(xi,eta,psi,floor(min(min(psi))):.25:ceil(max(max(psi))),'b')
hold on
contour(xi,eta,phi,floor(min(min(phi))):.25:ceil(max(max(phi))),'r--')
set(gca,'color','white')
grid on
axis('equal')
ylabel('eta');
xlabel('xi');
title('Funções Potencial e Corrente: Phi (tracejado vermelho); Psi (linha azul)');

% Plotagem das Funções Potencial e Corrente no plano z
figure(2)
contour(x,y,psi,floor(min(min(psi))):.25:ceil(max(max(psi))),'b')
hold on
contour(x,y,phi,floor(min(min(phi))):.25:ceil(max(max(phi))),'r--')
set(gca,'color','white')
grid on
axis('equal')
ylabel('y');
xlabel('x');
title('Funções Potencial e Corrente: Phi (tracejado vermelho); Psi (linha azul)');
