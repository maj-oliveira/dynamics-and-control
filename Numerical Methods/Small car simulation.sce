// Questão 1 - 17/08/2018

//CONSTANTES
m = 0.03; // Massa m em kg
g = 9.78; // Aceleração da gravidade em m/s^2
c = 9.2*10^-6; // Constante de dissipação angular viscosa
teta = %pi/6;


//Geração do vetor de instantes de tempo para o integrador
t0 = 0.0; // Instante de tempo inicial
tf = 6.0; // Instante de tempo final
dt = 0.01; // Intervalo de tempo
t = t0:dt:tf; // Vetor de tempo indo de t0 a tf em intervalos dt

//Definição das condições iniciais
x0 = 0.0; // Posição inicial da partícula
xponto0 = 1.0; // Velocidade inicial da partícula

//Equação dinâmica do sistema declarada em espaço de estados

function dy = f(t,y)
    //A função fornecerá um vetor dy das derivadas de y, onde: 
    //y = [x; xponto; teta; tetaponto]
    //dy = [xponto;x2pontos;tetaponto;teta2pontos]
    x = y(1)
    xdot = y(2)
    
    dy(1) = xdot;
    dy(2) = -c/m*xdot + g*sin(teta);
endfunction

//Integração da função f para as condições iniciais yO, começando em t0 nos instantes t  
y0 = [x0; xponto0];
y = ode(y0, t0, t, f);

//Vetores com valores de x, xponto, teta e tetaponto a serem plotados
//y tem em suas casas y = [x(t); x_ponto(t); teta(t); teta_ponto(t)]
x = y(1,:);
xponto = y(2,:);

//Plotagem dos gráficos
f1 = scf(1);
f1.figure_position = [0,0]
f1.figure_size=[1400,700]

subplot(3,2,1) //f2 = scf(2) //Se quiser o gráfico em janela separada
plot(t,x);
xtitle("Posição x em função do tempo");
xlabel ('tempo(s)')
ylabel ('Posição x (m)')
xgrid

//f3 = scf(3) //Se quiser o gráfico em janela separada
subplot(3,2,2)
plot(t,xponto);
xtitle("X ponto em função do tempo");
xlabel ('tempo(s)')
ylabel ('X ponto (m/s)')
xgrid

//f7 = scf(7) //Se quiser o gráfico em janela separada
subplot(3,2,6)
plot(x,xponto);
xtitle("X ponto em função de x");
xlabel ('x(m)')
ylabel ('X ponto (m/s)')
xgrid
