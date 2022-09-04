pkg load control

%EX1
%DETERMINANDO Kp
sys1 = tf('s');
GH = (s+1)/(s^4+3*s^3+12*s^2-16*s);
%figure(1)
%rlocus(GH)
r=-0.17612+2.18188*i;
Kp=(r^4+3*r^3+12*r^2-16*r)/(-r-1);
Kp=real(Kp);

%DETERMINANDO Kd
sys2 = tf('s');
GH2 = (s^2+s)/(Kp*(s+1)+s^4+3*s^3+12*s^2-16*s);
%figure(2)
%rlocus(GH2)
rd=-0.52306+0*i
Kd=-1/((rd^2+rd)/(Kp*(rd+1)+rd^4+3*rd^3+12*rd^2-16*rd));
Kd=real(Kd);

%SIMULAÇÃO MALHA ABERTA
sys3 = tf('s');
T1=(GH)/(1+GH);
%figure(3)
%step(T1)

%SIMULAÇÃO P
sys4 = tf('s');
T1=(Kp*GH)/(1+Kp*GH);
%figure(4)
%step(T1)

%SIMULAÇÃO PD
sys4 = tf('s');
T1=((Kp+Kd*s)*GH)/(1+(Kp+Kd*s)*GH);
%figure(5)
%step(T1)

%EX2

sys4 = tf('s');
G=1/(s+1)
H=1/(s^2+4*s+5)
r=-2+0*i
Kp=-(r^2+4*r+5)*(r+1);
Kp=real(Kp)
%T=Kp*G/(1+Kp*G*H)
%figure(1)
%rlocus(G*H)
%figure(2)
%step(T)

%EX3
sys5 = tf('s');
GH5=(s^2+1)/(s*(s+1))
rlocus(GH5)