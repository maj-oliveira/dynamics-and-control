// Definicao da funcao que implementa a equacao nao linear
function hdot=tanque(t,h,Qe)
    x1 = h(1)-h10;
    x2 = h(2)-h20;
    u = 0;
    a = sqrt((rho*g)/(Ra*(h10-h20)))/(2*S1);
    b = sqrt((rho*g)/(Rs*(h20)))/(2*S2);
    disp((sqrt(rho*g*(h10-h20)/Ra) - sqrt(rho*g*h20/Rs))/S2)
    hdot(1) = -a*x1+a*x2+u/S1
    hdot(2) = a*x1-(a+b)*x2
endfunction

// Definicao da funcao que implementa a entrada Qe:
function [u]=entrada(t)
    u=Qei;
// supondo o exemplo, u=K1*sin(w*t)+K2*t^(-2)
endfunction
