clear
close all
clc
%% Load the file
[f p]=uigetfile('*.mat','Please specify the file to open');
cd(p);
load(f);

%% Calculating auto-correlation and tau vector
%%%%Determine the sampling interval and the number of samples, plot the
%%%%graph of the signal in time domain

dt=1/fsamp;
N=length(Data);
t=0:dt:dt*(N-1);
Data=Data./sens;
figure;
set(gca, 'fontsize', 14)
plot(t,Data),
title('Radial acceleration','fontsize',16);
xlabel('t [s]','fontsize',16)
ylabel('[m/s^2]','fontsize',16)
grid on;


%%
%Initialize the variables for autocorrelation and the respective tau
auto=zeros(1,N);
tau=zeros(1,N);

%Calculating the autocorrelation
for z=0:N-1
    sig1=Data(1:N-z);
    sig2=Data(1+z:N);
    product=sig1.*sig2;
    auto(z+1)=sum(product)/(N-z);
    tau(z+1)=z*dt;
end

auto_tot=[auto(end:-1:1) auto(2:end)];
tau_tot=[-fliplr(tau) tau(2:end)];
% sum=0;
% n_signals=length(Data);
% for i=1:n_signals
%     sum=0;
%     for j=1:n_signals-i
%         sum = sum + (Data(j,1)*(Data(j+i,1)));
%     end
%     pos_ac(i,1) =sum / (n_signals-i);
% end
%%
%Plot the result of the autocorrelation
figure(100);
set(gca, 'fontsize', 14)
plot(tau_tot,auto_tot)
title('Autocorrelation','fontsize',16)
xlabel('tau [s]','fontsize',16)
ylabel('m^2/s^4','fontsize',16)
grid on
hold on

%% Autocorrelation function with xcorr
coefauto=xcorr(Data,'biased');
coefautou=xcorr(Data,'unbiased');


figure
set(gca, 'fontsize', 14)
plot(tau_tot,coefauto),title('Autocorrelation Xcorr biased','fontsize',16)
xlabel('tau [s]','fontsize',16)
ylabel('m^2/s^4','fontsize',16)
grid on
hold on

figure
set(gca, 'fontsize', 14)
plot(tau_tot,coefautou),title('Autocorrelation Xcorr unbiased','fontsize',16)
xlabel('tau [s]','fontsize',16)
ylabel('m^2/s^4','fontsize',16)
grid on
hold on

%% Speed estimation

[val,loc]=findpeaks(auto_tot((N-1):2*end/3),'MinPeakHeight',2.5*10000);

%plot the peak position in the graph of the autocorrelation

figure(100)
hold on
plot((loc-2)*dt,val,'*r')
%%
%wheel radius in meters (diameter 16 inches)
r=16/2*0.0254;

%Calculating the speed of rotation
periods=diff(loc)*dt;

%%

period=loc(2)-loc(1);
omega=2*pi/(period*dt);  % rad/s
v=omega*r;  % m/s
% speed in km / h
v=v*3.6;  

%Display the velocity
disp(['The speed is: ' num2str(v) ' km/h']);

% velocity for the first 10 periods
periods=loc(2:end)-loc(1:end-1);
omega_v=2*pi./(periods*dt);  % rad/s
v_v=omega_v*r;  % m/s
% speed in km / h
v_v=v_v*3.6; 

%% Time - averaging
%Split the signal into a period of long stories
% number of periods
Ns=floor(length(Data)/period)

for i=1:Ns
    Sig(:,i)=Data((i-1)*period+1:i*period)-mean(Data((i-1)*period+1:i*period));
end

%Averaging
medium2=mean(Sig,2);
figure
set(gca, 'fontsize', 14)
hold on
grid on
plot(t(1:period),medium2,'b',t(1:period),Sig,'r')
legend('Time Averaging','Original signal')
title('Original signal','fontsize',16)
xlabel('t [s]','fontsize',16)
ylabel('m/s^2','fontsize',16)
plot(t(1:period),medium2,'b','linewidth',2)
xlim([0 0.15]);
