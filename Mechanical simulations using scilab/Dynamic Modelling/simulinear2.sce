//parametros
m = 250;
ms = 300;
ks = 14213;
k = 15000;
b = 1885;
g = 9.8;
l=0.4;
t = 0:0.1:1000;

//variaveis
X0 = [0,0,0,0,0]
//X0 = [x,xs,xg,dx,dxs]

//entradas
u=0
F=0
dxg=0

entrada = [u,F,dxg]
entrada0 = [0,0,0]

//sistema
function [xdot]=sistema(t,X,entrada)
    x = X(1);
    xs = X(2);
    xg = X(3);
    dx = X(4);
    dxs = X(5);
    
    //u = entrada(1);
    //F = entrada(2);
    //dxg = entrada(3);
    
    if x-xg>l then
       ddx=(-ks*(x-xs)-b*(dx-dxs)+u-m*g)/m
       ddxs=(-ks*(xs-x)-b*(dxs-dx)-u-F-ms*g)/ms
    end

    if x-xg <= l then
       ddx=(-k*(x-xg)-ks*(x-xs)-b*(dx-dxs)+u-m*g)/m
       ddxs=(-ks*(xs-x)-b*(dxs-dx)-u-F-ms*g)/ms
    end
    
    [xdot] = [ddx; ddxs; dx; dxs];
endfunction

//entrada
function [ut]=entrada(t)
    [ut]=[u;F;dxg]
endfunction

//integração da eq diferencial
[X] = ode(X0,0,t,list(sistema,entrada));

//gráficos
plot2d(t,X(1,:),2)
