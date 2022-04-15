//vars do sistema
l=0.213
m=0.1
gr=9.81
theta0=%pi/180
thetapto0=0
t0=0
tf=30
omhega=sqrt(6*gr/(7*l))
y0=[theta0;thetapto0]
c=0.002

dt=0.01
t=[t0:dt:tf]

//função deriva
function [dy]=f(t,y)
    y1=y(2) //theta
    y2=-omhega*omhega*sin(y(1)) //theta 2 pontos
    dy=[y1;y2]
endfunction

y=ode(y0,t0,t,f)
ec = 7*m*l*l*y(1,:)^2/6

//plot
scf(0)
xgrid

//theta e thetaponto
//plot2d(t,y(1,:)) //theta
//plot2d(t,y(2,:)) //thetaponto

//energia cinética
plot(t,ec(:),"g")

//espaço de fases
//plot(y(1,:),y(2,:),'b')

//Dissipação
function [dy]=ff(t,y)
    y1=y(2) //theta
    y2=(-2*gr*sin(y(1)+0.002*sin(omhega*t))/(7*l/3)) //theta 2 pontos
    dy=[y1;y2]
endfunction

scf(1)
y=ode(y0,t0,t,ff)
plot(t,y(1,:),"r")
