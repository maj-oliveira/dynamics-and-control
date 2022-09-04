A = 0.0075
Cd=0.3
m = 0.030
ro=1.2
g=9.78;
theta=%pi/6;
h=0.01; //passo
t0=0;
dt=h;
tf=60;
t=[t0:dt:tf];
n = length (t);


//RungeKutta
function [s,v] = kutta(s0,v0)
    s(1)=s0
    v(1)=v0
    for i = 1:n-1
        F1=-(1/(2*m)*ro*v(i)^2*A*Cd)+g*sin(theta);
        F2=-(1/(2*m)*ro*(v(i)+h*F1)^2*A*Cd)+g*sin(theta);
        v(i+1)=v(i)+(h/2)*(F1+F2)
        s(i+1)=s(i)+h*v(i+1);
    end
    
endfunction

//Euler Implícito
function [s,v] = eulerimplicito(s0,v0)
    
    s(1) = s0
    v(1) = v0
    for i = 1:n-1
        v(i+1) = (-1 +(1 - 4*(0.5*ro*Cd*h*(A/m))*(-v(i)-g*h*sin(theta)))^0.5)/(ro*Cd*A*(h/m))
        s(i+1) = s(i) + h*v(i+1)
    end
endfunction

//Para os métodos abaixo

function z = dvdt(s,v)
    z = g*sin(theta) - (0.5)*ro*Cd*A*(1/m)*(v)^2
endfunction

function z = dsdt(s,v)
    z = v
endfunction

//Euler Explicito

function [s,v] = eulerexplicito(s0,v0)
    s(1) = s0
    v(1) = v0
    for i = 1:n-1
        is = dsdt(s(i),v(i))
        iv = dvdt(s(i),v(i))
        s(i+1) = s(i) + h*is
        v(i+1) = v(i) + h*iv
    end
endfunction

//heun
function [s,v] = heun(s0,v0)
    s(1) = s0
    v(1) = v0
    for i = 1:n-1
        k1s = dsdt(s(i),v(i))
        k1v = dvdt(s(i),v(i))
        k2s = dsdt(s(i)+k1s*h,v(i)+k1v*h) 
        k2v = dvdt(s(i)+k1s*h,v(i)+k1v*h)
        k1sdef = 0.5*(k1s+k2s)
        k2vdef = 0.5*(k1v+k2v)
        s(i+1) = s(i) + h*k1sdef
        v(i+1) = v(i) + h*k2vdef
    end
endfunction

//Euler melhorado

function [s,v] = eulermelhorado(s0,v0)
    s(1) = s0
    v(1) = v0
    for i = 1:n-1
        k1s = dsdt(s(i),v(i))
        k1v = dvdt(s(i),v(i))
        k2s = dsdt(s(i)+k1s*h/2,v(i)+k1v*h/2)
        k2v = dvdt(s(i)+k1s*h/2,v(i)+k1v*h/2)
        s(i+1) = s(i) + h*k2s
        v(i+1) = v(i) + h*k2v
    end
endfunction

//Plots
//kutta

[s,v] = kutta(0,1)
f1 = scf(1)
plot(t,s,'x-')
xtitle("Posição x em função do tempo");
xlabel ('tempo(s)')
ylabel ('Posição x (m)')
xgrid
f2 = scf(2)
plot(t,v,'x-')
xtitle("X ponto em função do tempo");
xlabel ('tempo(s)')
ylabel ('X ponto (m/s)')
xgrid

disp(s(tf/h+1))

//euler implicito
[s,v]=eulerimplicito(0,1)
f1 = scf(1)
plot(t,s,'r')
f2 = scf(2)
plot(t,v,'r')

disp(s(tf/h+1))

//euler explicito
[s,v]=eulerexplicito(0,1)
f1 = scf(1)
plot(t,s,'ok')
f2 = scf(2)
plot(t,v,'ok')

disp(s(tf/h+1))

//heun
[s,v]=heun(0,1)
f1 = scf(1)
plot(t,s,'co')
f2 = scf(2)
plot(t,v,'co')

disp(s(tf/h+1))

//Euler melhorado
[s,v]=eulermelhorado(0,1)
f1 = scf(1)
plot(t,s,'m.')
f2 = scf(2)
plot(t,v,'m.')

disp(s(tf/h+1))
