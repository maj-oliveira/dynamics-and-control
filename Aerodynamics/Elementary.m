%  by Prof. Dr. E. V. Volpe, Matheus Oliveira version

clc
clear all
close all

N        = 200;
G        = 10;
S        = -10;
a        = 1.0;
Uoo      = 5.0;
alphadeg = 30; 

dt     = 1e-3;
dr     = dt;

lt     = pi-dt;
rk     = linspace(dr,1,N);
tk     = linspace(-lt,lt,N);
[R,T]  = meshgrid(rk,tk);
Z      = R.*exp(1i*T);
X      = real(Z);
Y      = imag(Z);
F      = log(R) + 1i*T;

% Uniform potential flow at an angle
alpha  = alphadeg*pi/180;
Fu = Uoo*exp(-1i*alpha)*Z;
phiu  = real(Fu);
psiu  = imag(Fu);
Wu = Uoo*exp(-1i*alpha)*ones(size(X));
Uu = conj(Wu);
uux   = real(Uu);
uuy   = imag(Uu);

% Point vortex
cv    = -1i*G/(2*pi);
Fv    = cv*F;
phiv  = real(Fv);
psiv  = imag(Fv);
W     = cv./Z;
Uv    = conj(W);
uvx   = real(Uv);
uvy   = imag(Uv);

% Point source
cs    = S/(2*pi);
Fs    = cs*F;
phis  = real(Fs);
psis  = imag(Fs);
W     = cs./Z;
Us    = conj(W);
usx   = real(Us);
usy   = imag(Us);

% Dipole (Doublet) Potential Flow
A  = -2*Uoo/(2*pi);
mu = -2*pi*A; 
Ro = sqrt(mu/(2*pi*Uoo));
Fd = -A./Z;
phid  = real(Fd);
psid  = imag(Fd);
Wd = A./(Z.^2);
Ud = conj(Wd);
udx   = real(Ud);
udy   = imag(Ud);

% Generic example
Ft    = Fs + Fv + Fu + Fd;
Ut    = Uv + Us + Uu + Ud;
phit  = real(Ft);
psit  = imag(Ft);
utx   = real(Ut);
uty   = imag(Ut);


% Graphics
figure(1),
%contour(X,Y,psiv,80);
hold on
%contour(X,Y,phiv,60);
quiver(X,Y,uvx,uvy,5,'m');
grid on;
axis('square'); 
xlabel('x');
ylabel('y');
title('Point Vortex');

figure(2),
contour(X,Y,psis,80);
hold on
contour(X,Y,phis,60);
quiver(X,Y,usx,usy,0.5,'m');
grid on;
axis('square'); 
xlabel('x');
ylabel('y');
title('Point Source');

figure(3),
contour(X,Y,psiu,40);
hold on
contour(X,Y,phiu,20);
%quiver(X,Y,uux,uuy,0.1,'m');
grid on;
axis('square'); 
xlabel('x');
ylabel('y');
title('Uniform flow at an angle');

figure(4),
contour(X,Y,psid,100);
hold on
contour(X,Y,phid,80);
%quiver(X,Y,udx,udy,0.1,'m');
grid on;
axis('square'); 
xlabel('x');
ylabel('y');
title('Dipole (doublet)');

figure(5),
contour(X,Y,psit,80);
hold on
contour(X,Y,phit,60);
%quiver(X,Y,utx,uty,0.5,'m');
grid on;
axis('square'); 
xlabel('x');
ylabel('y');
title('Generic Example');




