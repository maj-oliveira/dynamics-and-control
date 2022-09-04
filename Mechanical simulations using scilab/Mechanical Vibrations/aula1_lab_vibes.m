Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

X1=0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
X2=10+X1

%plot(1000*t(1:50),X1(1:50))

Y1 = fft(X1);
Y2=fft(X2);

f = Fs*(0:(L/2))/L;

P2 = abs(Y1/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

P3 = abs(Y2/L);
P4 = P3(1:L/2+1);
P4(2:end-1) = 2*P4(2:end-1);

plot(f,P4)