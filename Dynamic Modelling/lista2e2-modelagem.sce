//Parameters
S_1 = 10; //area
S_2 = 10; //area
R_a = 2e8; //fluid mechanics parameter
R_s = 2e8; //fluid mechanics parameter
rho = 1000; //mass density
G = 10; //gravity

//Variables
Q_e = 0.010247;
t0 = 0.0; //time initial
tf = 10000.0;// time final
step = 0.1; // step
h1_0 = 0.0;
h2_0 = 0.0;
t = t0:step:tf; //time

function [x,y] = euler(t,x0,y0)
    y(1) = y0;
    x(1) = x0;
    for i=1:(tf)/step
        x_t = (Q_e-sqrt((rho*G/R_a)*(y(i)-x(i))))*(1/S_1)*step
        y_t = (sqrt((rho*G/R_a)*(y(i)-x(i)))-sqrt(rho*G*x(i)/R_s))*(1/S_2)
        x(i+1) = x(i)+x_t
        y(i+1) = y(i)+y_t
        
        if y(i+1)<0 then
            y(i+1) = 0
        end
        if x(i+1)<0 then
            x(i+1) = 0
        end
    end
endfunction

[x,y] = euler(tf,h1_0,h2_0)
plot2d(t,x)
plot2d(t,y)
