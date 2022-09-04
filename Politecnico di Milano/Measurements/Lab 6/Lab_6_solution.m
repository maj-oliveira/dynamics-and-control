clc
clear
close all

% open data file
[n p]=uigetfile('.mat','Select the data file');
cd(p);
load(n);

%% Plot of the data

% plot accelerometer data
N=length(Data);
dt=1/fsamp;
T=N*dt;
df=1/T;
t=0:dt:(N-1)*dt;
figure
plot(t/60,Data)
set(gca,'fontsize',14)
xlabel('Time [min]')
ylabel('Acc [m/s^2]')
axis tight
grid on
hann=hanning(N);
% hann=ones(N,1);
Datah=Data.*hann;

%% Plot of the spectrum, power spectrum and PSD of the whole signal

% computing spectrum
[A, frequency]=fft_n(Datah,fsamp);
A_star=conj(A);

% computing power spectrum
SAA=A_star.*A;
SAA(2:end)=SAA(2:end)./2;
% computing Power Spectrum Density (PSD)
PSD=SAA./df;

% plotting 'Spectrum','Power spectrum','PSD'
figure
semilogy(frequency,abs(A),'b')
hold on
semilogy(frequency,SAA,'r')
semilogy(frequency,PSD,'m')
set(gca,'fontsize',14)
grid on
legend('Spectrum','Power spectrum','PSD')
title('Whole data set')
xlabel('Frequency [Hz]')
ylabel('|A| - S_A_A - PSD')
xlim([0.5 10]);

%% Methods for the averaging process

% ris=resolution of spectrum
ris=0.1;
% time interval for computing one single spectrum for averaging
fin=1./ris;
% number of point of the time interval for computing one single spectrum for averaging
n_point=fin.*fsamp;

% computing 'Spectrum','Power spectrum','PSD' for all intervals
for kk=1:floor(length(Data)/n_point)
    [sp frequency1]=fft_n(Data(n_point*(kk-1)+1:kk*n_point).*hanning(n_point),fsamp);

    SAA_kk=conj(sp).*sp;
    SAA_kk(2:end)=SAA_kk(2:end)./2;

    SP_MAT_ris1(:,kk)=sp;   
    SAA_MAT_ris1(:,kk)=SAA_kk;   

end

% computing average for spectrum
SP_aver_ris1=sum(SP_MAT_ris1,2)./floor(length(Data)/n_point); 

% computing average for power spectrum
SAA_av_1_ris1= conj(SP_aver_ris1).*SP_aver_ris1;
SAA_av_1_ris1(2:end)=SAA_av_1_ris1(2:end)./2 ;

SAA_av_2_ris1=sum(SAA_MAT_ris1,2)./floor(length(Data)/n_point); 
% computing average for PSD
PSD_ris1=SAA_av_2_ris1./ris;

clear ris sp fin n_punti asp

ris=0.05;
fin=1./ris;
n_point=fin.*fsamp;

for kk=1:floor(length(Data)/n_point)
    [sp frequency2]=fft_n(Data(n_point*(kk-1)+1:kk*n_point).*hanning(n_point),fsamp); % hanning
    SAA_kk=conj(sp).*sp;
    SAA_kk(2:end)=SAA_kk(2:end)./2;

    SP_MAT_ris2(:,kk)=sp;      
    SAA_MAT_ris2(:,kk)=SAA_kk;   
end
SP_aver_ris1_2=mean(SP_MAT_ris2,2);

SAA_av_1_ris1_2= conj(SP_aver_ris1_2).*SP_aver_ris1_2;
SAA_av_1_ris1_2(2:end)=SAA_av_1_ris1_2(2:end)./2;

SAA_av_2_ris2=mean(SAA_MAT_ris2,2); 
PSD_ris2=SAA_av_2_ris2./ris;

%% Plot of the results

figure
semilogy(frequency1,abs(SP_aver_ris1),'b','linewidth',2)
hold on
semilogy(frequency2,abs(SP_aver_ris1_2),'r','linewidth',2)
set(gca,'fontsize',14)
title('Average spectrum')
xlabel('Frequency [Hz]')
ylabel('|A| [m/s^2]')
legend('df=0.1','df=0.05')
xlim([0.5 10]);
grid

figure
semilogy(frequency1,(SAA_av_2_ris1),'b','linewidth',2)
hold on
semilogy(frequency2,(SAA_av_2_ris2),'r','linewidth',2)
set(gca,'fontsize',14)
title('Average power spectrum')
xlabel('Frequency [Hz]')
ylabel('|A| [(m/s^2)^2]')
legend('df=0.1','df=0.05')
xlim([0.5 10]);
grid

figure
semilogy(frequency1,(SAA_av_2_ris1),'b','linewidth',2)
hold on
semilogy(frequency2,(SAA_av_2_ris2),'r','linewidth',2)
semilogy(frequency1,(SAA_av_1_ris1),'c','linewidth',2)
semilogy(frequency2,(SAA_av_1_ris1_2),'m','linewidth',2)
set(gca,'fontsize',14)
title('Power spectra')
xlabel('Frequency [Hz]')
ylabel('|A| [(m/s^2)^2]')
legend('Am df=0.1','Am df=0.05', 'A-Sm df=0.1', 'A-Sm df=0.05')
xlim([0.5 10]);
grid

figure
semilogy(frequency1,PSD_ris1,'b','linewidth',2)
hold on
semilogy(frequency2,PSD_ris2,'r','linewidth',2)
set(gca,'fontsize',14)
title('PSD')
xlabel('Frequency [Hz]')
ylabel(' [(m/s^2)^2/Hz]')
legend('df=0.1','df=0.05')
xlim([0.5 10]);
grid


figure (5)
figure (4)
figure (3)
figure (2)
figure (1)