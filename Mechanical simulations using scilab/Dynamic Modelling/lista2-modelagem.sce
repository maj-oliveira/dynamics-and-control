//Parameters
S = 10; //area
R = 2e8; //fluid mechanics parameter
rho = 1000; //mass density
G = 10; //gravity

//Variables
Q_e = 0.010247;
t0 = 0.0; //time initial
tf = 10000.0;// time final
step = 0.1; // step
h0 = 0.0;
t = t0:step:tf; //time

function [h_dot] = height_dot(h)
    h_dot = (-sqrt(rho*G*h/R)+Q_e)/S;
endfunction

//euler method
function [y] = euler(t,y0)
    y(1) = y0;
    for i=1:(tf)/step
        y(i+1) =  y(i) + step*height_dot(y(i))
    end
endfunction

//runge-kutta method
function [y] = RK(t,y0)
    y(1) = y0;
    for i=1:(tf)/step
        k1 = height_dot(y(i));
        k2 = height_dot(y(i)+(step*k1/2))
        k3 = height_dot(y(i)+(step*k2/2))
        k4 = height_dot(y(i)+(step*k3/2))
        
        y(i+1) =  y(i) + (step/6)*(k1+2*k2+2*k3+k4)
        
    end
endfunction

h = RK(tf,h0)

xtitle("Altura da água no tanque em função do tempo");
plot2d(t,h);
