//declaração de variaveis
l=0.213;
m=0.1;
g=9.81;
teta_lim = -%pi/8
teta0 = %pi -0.0001;
tetapto0 = 0;

//tempo
t0 = 0.0;
dt =0.01;
tf=30;
t = t0:dt:tf;

omhegan = sqrt(3*g/(8*l));
z0 =[teta0;tetapto0];
c = 0.002;
e=0.8;

//função deriva
function [z_dot] = deriva(t,z)
    teta = z(1,:);
    teta_dot = z(2,:);
    dteta_dt = teta_dot;
    //d2teta_dt2 = -(6*g*sin(teta))/(7*l) - (3/(7*m*l^2))*c*teta_dot;
    d2teta_dt2 = -(9*g*sin(teta))/(16*l) - (3/(16*m*l^2))*c*teta_dot
    //disp(dteta_dt,d2teta_dt2)
    z_dot = [dteta_dt; d2teta_dt2]
endfunction

function [parou] = parada(t,z)
    //disp(z(1))
    parou = z(1) - teta_lim
endfunction

z_mov=[]
t_mov=[]
while t0<tf
//z = ode(z0,t0,t,deriva);
    [z rd] = ode("root",z0,t0,t,deriva, 1, parada)
    if t0~=0 then disp('ok') end
    //t(n_mov) = rd(1,1)
    t_mov=[t_mov,t0:dt:rd(1,1)]
    if modulo(rd(1,1),dt) ~= 0 then
        t_mov=[t_mov,rd(1,1)];
    end
    t0 = rd(1,1)
    t = t0:dt:tf
    
    z_mov = [z_mov,z]
    //t_mov =[t_mov, t(1:n_mov)]
    n_mov = length(z(1))
    teta0=-%pi/8
    tetapto0=-e*z(2,n_mov)
    z0=[teta0;tetapto0]
        
//y = ode(y0, t0, t, f)
end

//plotar
f1 = scf(1)
    plot(t_mov,z_mov(1,:))
f2 = scf(2)
    plot(t_mov,z_mov(2,:))
f3 = scf(3)
    comet(z_mov(1,:),z_mov(2,:))
