%  by Prof. Dr. E. V. Volpe, Matheus Oliveira version
clc
clear all
close all

N     = 100;
% Z in polar coordinates,
% which is not been used here
% but it serves as an example
% r     = linspace(0,2,N);
% theta = linspace(-pi,pi,N);
% [R,T] = meshgrid(r,theta);
% Zp    =  R.*exp(1i*T);
% Z in Cartesian coordinates
x     = linspace(-4,6,N);
y     = linspace(-5,5,N);
[X,Y] = meshgrid(x,y);
Zc    = X + 1i*Y;
% Far-Field velocity parallel to the x axis
Uoo   = 1.0;
sig   = 30.0;

% Uniform flow in the positive x direction
F1     = Uoo*Zc;
% Source at the origin 
F2     = (sig/(2*pi))*log(Zc);
% Sink at Z = 1 + i*0
F3     = -(sig/(2*pi))*log(Zc-2); 

% Complex Potential 
Ft     = F1 + F2 + F3;
Phi    = real(Ft);
Psi    = imag(Ft);
% Complex Velocity W = dF/dZ
W      = Uoo + (sig/(2*pi))./Zc -(sig/(2*pi))./(Zc-2);
% Physical Velocity U = Conj(W)
U       = conj(W);
Up      = real(U);
Vp      = imag(U);
%[Up,Vp] = meshgrid(up,vp);
%%%%%%%%%%%% COMPUTING C_p %%%%%%%%%%%%%%%
Cp    = 1 - (Up.^2 + Vp.^2)/(Uoo^2);
%%%%%%%%%%%% Prandtl-Glauert Correction


% figures
figure(1),
contour(X,Y,Phi,55,'r--');
hold on
contour(X,Y,Psi,55,'b-');
quiver(X,Y,Up,Vp,5,'g');
grid on
axis('square');
xlabel('x');
ylabel('y');
title('Potential and Streamlines: \Phi, red dashed lines; \Psi, blue solid lines');

%for k=1:N
%    for s=1:N
%        if (abs(Cp(k,s))>=1e1)
%            Cp(k,s) = NaN;
%        end;
%    end
%end

  
% %error('test');
% figure(2),
% %contour(X,Y,Cp,55);
% meshc(X,Y,Cp);
% hold on
% grid on;
% axis('normal');
% xlabel('x');
% ylabel('y');
% zlabel('C_p');
% title('Pressure Coefficient');
% 
% % this figure shows 3-D plottings of Phi and Psi
% figure(3),
% meshc(X,Y,Phi);
% hold on
% grid on;
% axis('normal');
% xlabel('x');
% ylabel('y');
% zlabel('\Phi');
% title('Potential Function');
% 
% 
% figure(4),
% meshc(X,Y,Psi);
% hold on
% grid on;
% axis('normal');
% xlabel('x');
% ylabel('y');
% zlabel('\Psi');
% title('Stream Function');