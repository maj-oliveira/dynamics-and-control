% ###########################################################
% Matheus José Oliveira dos Santos - N°USP:10335826
% Prova 1
% PME 3555 - 2022 - Prof. Dr. Ponge
% ###########################################################

clear all
close all
clc

%% parâmetros
b = 0.5; %[m]
h = 0.25; %[m]
t = 20*10^-3; %[m]
E = 210*10^9; %[Pa]
v = 0.3;
s = 160000; %[N/m]

%% Montando a matriz de rigidez global

k1=LinearTriangleElementStiffness(E,v,t,0,0,0,h,b,h,1);
k2=LinearTriangleElementStiffness(E,v,t,0,0,b,h,b,0,1);

K = zeros(8,8);
K = LinearTriangleAssemble(K,k1,1,2,3);
K = LinearTriangleAssemble(K,k2,1,3,4);

%% Solução
F = [0; 0; 0; 0; 0; -s*h/2; 0; -s*h/2];
K2=K([5:8],[5:8]);
F2 = F([5:8]);
d2=K2\F2;
d=[0;0;0;0;d2]*(-1)
F=K*d

%% Desenho
P1 = [0 0];
P2 = [0 h];
P3 = [b h];
P4 = [b 0];

hold on
desenhar_linha(P1, P2,"r")
desenhar_linha(P2, P3,"r")
desenhar_linha(P3, P4,"r")
desenhar_linha(P4, P1,"r")
desenhar_linha(P1, P3,"r")

multiplicador=100;
P1 = [0+d(1)*multiplicador 0+d(2)*multiplicador];
P2 = [0+d(3)*multiplicador h+d(4)*multiplicador];
P3 = [b+d(5)*multiplicador h+d(6)*multiplicador];
P4 = [b+d(7)*multiplicador 0+d(8)*multiplicador];

plot(P1(1),P1(2),"o")
plot(P2(1),P2(2),"o")
plot(P3(1),P3(2),"o")
plot(P4(1),P4(2),"o")

desenhar_linha(P1, P2,"b")
desenhar_linha(P2, P3,"b")
desenhar_linha(P3, P4,"b")
desenhar_linha(P4, P1,"b")
desenhar_linha(P1, P3,"b")

title("representação dos deslocamentos ampliado x100")
xlabel("x [m]")
ylabel("y [m]")
grid on

%% Estado de tensões

d1 = d(1:6)
d2 = d([1:2,5:8])

sigma1=LinearTriangleElementStresses(E,v,0,0,0,h,b,h,1,d1)
sigma2=LinearTriangleElementStresses(E,v,0,0,b,h,b,0,1,d2)

%% Tensões principais

sigmaP1 = LinearTriangleElementPStresses(sigma1)
sigmaP2 = LinearTriangleElementPStresses(sigma2)

%% funções
function y = LinearTriangleElementArea(xi,yi,xj,yj,xm,ym)
    y = (xi*(yj-ym) + xj*(ym-yi) + xm*(yi-yj))/2;
end

function y = LinearTriangleElementStiffness(E,NU,t,xi,yi,xj,yj,xm,ym,p)

    A = (xi*(yj-ym) + xj*(ym-yi) + xm*(yi-yj))/2;
    betai = yj-ym;
    betaj = ym-yi;
    betam = yi-yj;
    gammai = xm-xj;
    gammaj = xi-xm;
    gammam = xj-xi;
    
    B = [betai 0 betaj 0 betam 0 ;
        0 gammai 0 gammaj 0 gammam ;
        gammai betai gammaj betaj gammam betam]/(2*A);
    
    if p == 1
        D = (E/(1-NU*NU))*[1 NU 0 ; NU 1 0 ; 0 0 (1-NU)/2];
    elseif p == 2
        D = (E/(1+NU)/(1-2*NU))*[1-NU NU 0 ; NU 1-NU 0 ; 0 0 (1-2*NU)/2];
    end
    y = t*A*B'*D*B;
end

function y = LinearTriangleAssemble(K,k,i,j,m)
%LinearTriangleAssemble This function assembles the element
% stiffness matrix k of the linear
% triangular element with nodes i, j,
% and m into the global stiffness matrix K.
% This function returns the global stiffness
% matrix K after the element stiffness matrix
% k is assembled.
    K(2*i-1,2*i-1) = K(2*i-1,2*i-1) + k(1,1);
    K(2*i-1,2*i) = K(2*i-1,2*i) + k(1, 2);
    K(2*i-1,2*j-1) = K(2*i-1,2*j-1) + k(1,3);
    K(2*i-1,2*j) = K(2*i-1,2*j) + k(1,4);
    K(2*i-1,2*m-1) = K(2*i-1,2*m-1) + k(1,5);
    K(2*i-1,2*m) = K(2*i-1,2*m) + k(1,6);
    K(2*i,2*i-1) = K(2*i,2*i-1) + k(2,1);
    K(2*i,2*i) = K(2*i,2*i) + k(2,2);
    K(2*i,2*j-1) = K(2*i,2*j-1) + k(2,3);
    K(2*i,2*j) = K(2*i,2*j) + k(2,4);
    K(2*i,2*m-1) = K(2*i,2*m-1) + k(2,5);
    K(2*i,2*m) = K(2*i,2*m) + k(2,6);
    K(2*j-1,2*i-1) = K(2*j-1,2*i-1) + k(3,1);
    K(2*j-1,2*i) = K(2*j-1,2*i) + k(3,2);
    K(2*j-1,2*j-1) = K(2*j-1,2*j-1) + k(3,3);
    K(2*j-1,2*j) = K(2*j-1,2*j) + k(3,4);
    K(2*j-1,2*m-1) = K(2*j-1,2*m-1) + k(3,5);
    K(2*j-1,2*m) = K(2*j-1,2*m) + k(3,6);
    K(2*j,2*i-1) = K(2*j,2*i-1) + k(4,1);
    K(2*j,2*i) = K(2*j,2*i) + k(4,2);
    K(2*j,2*j-1) = K(2*j,2*j-1) + k(4,3);
    K(2*j,2*j) = K(2*j,2*j) + k(4,4);
    K(2*j,2*m-1) = K(2*j,2*m-1) + k(4,5);
    K(2*j,2*m) = K(2*j,2*m) + k(4,6);
    K(2*m-1,2*i-1) = K(2*m-1,2*i-1) + k(5,1);
    K(2*m-1,2*i) = K(2*m-1,2*i) + k(5,2);
    K(2*m-1,2*j-1) = K(2*m-1,2*j-1) + k(5,3);
    K(2*m-1,2*j) = K(2*m-1,2*j) + k(5,4);
    K(2*m-1,2*m-1) = K(2*m-1,2*m-1) + k(5,5);
    K(2*m-1,2*m) = K(2*m-1,2*m) + k(5,6);
    K(2*m,2*i-1) = K(2*m,2*i-1) + k(6,1);
    K(2*m,2*i) = K(2*m,2*i) + k(6,2);
    K(2*m,2*j-1) = K(2*m,2*j-1) + k(6,3);
    K(2*m,2*j) = K(2*m,2*j) + k(6,4);
    K(2*m,2*m-1) = K(2*m,2*m-1) + k(6,5);
    K(2*m,2*m) = K(2*m,2*m) + k(6,6);
    y = K;
end

function y = LinearTriangleElementStresses(E,NU,xi,yi,xj,yj,xm,ym,p,u)
    %LinearTriangleElementStressesThis function returns the element
    % stress vector for a linear
    % triangular element with modulus of
    % elasticity E, Poisson’s ratio NU,
    % coordinates of the
    % first node (xi,yi), coordinates of
    % the second node (xj,yj),
    % coordinates of the third node
    % (xm,ym), and element displacement
    % vector u. Use p = 1 for cases of
    % plane stress, and p = 2 for cases
    % of plane strain.
    % The size of the element stress
    % vector is 3 x 1.
    A = (xi*(yj-ym) + xj*(ym-yi) + xm*(yi-yj))/2;
    betai = yj-ym;
    betaj = ym-yi;
    betam = yi-yj;
    gammai = xm-xj;
    gammaj = xi-xm;
    gammam = xj-xi;
    B = [betai 0 betaj 0 betam 0 ;
    0 gammai 0 gammaj 0 gammam ;
    gammai betai gammaj betaj gammam betam]/(2*A);
    if p == 1
        D = (E/(1-NU*NU))*[1 NU 0 ; NU 1 0 ; 0 0 (1-NU)/2];
    elseif p == 2
        D = (E/(1+NU)/(1-2*NU))*[1-NU NU 0 ; NU 1-NU 0 ; 0 0 (1-2*NU)/2];
    end
    y = D*B*u;
end

function y = LinearTriangleElementPStresses(sigma)
    %LinearTriangleElementPStresses This function returns the element
    % principal stresses and their
    % angle given the element
    % stress vector.
    R = (sigma(1) + sigma(2))/2;
    Q = ((sigma(1) - sigma(2))/2)^2 + sigma(3)*sigma(3);
    M = 2*sigma(3)/(sigma(1) - sigma(2));
    s1 = R + sqrt(Q);
    s2 = R - sqrt(Q);
    theta = (atan(M)/2)*180/pi;
    y = [s1 ; s2 ; theta];
end

function desenhar_linha(P1, P2, cor)
    plot(P1(1),P1(2),"x")
    plot(P2(1),P2(2),"x")
    x = [P1(1),P2(1)];
    y = [P1(2),P2(2)];
    plot(x,y,cor)
end