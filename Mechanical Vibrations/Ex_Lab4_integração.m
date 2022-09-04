clear
clc

%% variaveis

alpha = 10*pi/180
e= 15*10^(-3) %[m]
R=50*10^(-3) %[m]
h = 24*10^(-3) %[m]
g = 9.8 %[m/s^2]
mu_rol = 0.1365
M = (61+29+150)*10^(-3)
m_cel = 150*10^(-3) %[g]
a=67.5*10^(-3)
b=8.6*10^(-3)
m_cil = 61*10^(-3) %[g]

%% momentos de inércia
Jg = m_cel*h^2 + (1/12)*m_cel*(a^2+b^2) + m_cil*R^2-M*e^2
J_cil_o = m_cil*R^2
J_cel_o = m_cel*h^2+(1/12)*m_cel*(a^2+b^2)

%% integração
step=0.1;                                          % step size
x = 0:step:10;                                      % Calculates upto y(3)
y = zeros(1,length(x)); 
y(1) = 5;                                          % initial condition
F_xy = @(t,r) 3.*exp(-t)-0.4*r;                    % change the function as you desire

for i=1:(length(x)-1)                              % calculation loop
    k_1 = F_xy(x(i),y(i));
    k_2 = F_xy(x(i)+0.5*step,y(i)+0.5*step*k_1);
    k_3 = F_xy((x(i)+0.5*step),(y(i)+0.5*step*k_2));
    k_4 = F_xy((x(i)+step),(y(i)+k_3*step));
    y(i+1) = y(i) + (1/6)*(k_1+2*k_2+2*k_3+k_4)*step;  % main equation
end


