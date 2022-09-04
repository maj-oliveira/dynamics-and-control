clear
close all
clc

set(groot, 'defaultFigureUnits','normalized')
set(groot, 'defaultFigurePosition',[0 0 1 1])
set(0,'defaultaxesfontsize',16);

%% PART 1 FFT

%% Load
load('Lab_5_Data_first_part.mat')

dt=1/fsamp;
N=length(Data1);
t=0:dt:(N-1)*dt;
esc=0;
while esc==0
    signal_to_load=menu('Choose a signal or move on','Data1','Data2','Data3','Data4','move on')
    switch(signal_to_load)
        case 1
            y=Data1;
        case 2
            y=Data2;
        case 3
            y=Data3;
        case 4
            y=Data4;
        case 5
             esc=1;
    end
    if esc==0
        figure(1)
        plot(t,y)
        grid on
        xlabel('time[s]')
        ylabel('amplitude')
        
        %% FFT
        k_var=N/2;
        DFTterm=zeros(N+1,1);
        for k=-k_var:1:k_var
            expterm=exp(-1i*2*pi*(k).*(0:N-1)./N);
            summation=sum(y.*expterm)./N;
            DFTterm(k+k_var+1)=summation;
        end
        
        %% FFT with k minimum and maximum multiplied by 4
        
        for k=-k_var*4:1:k_var*4
            
            expterm4=exp(-1i*2*pi*(k)*(0:N-1)./N);
            summation4=sum(y.*expterm4)./N;
            DFTterm4(k+k_var*4+1)=summation4;
            
        end
        
        T=N*dt;
        df=1/T;
        freq=-k_var.*df:df:(k_var)*df;
        freq4=-k_var*4.*df:df:(k_var*4)*df;
        
        figure(2)
        subplot(2,1,1)
        plot(freq,abs(DFTterm))
        grid on
        xlabel('freq [Hz]')
        ylabel('modulus')
        title('Fourier Transform')
        subplot(2,1,2)
        plot(freq,angle(DFTterm))
        grid on
        xlabel('freq [Hz]')
        ylabel('\phi [rad]')
        
        
        
        %% FFT with just the frequencies >= 0
        
        freq2=[0:df:(N/2)*df];
        trasf2=2*DFTterm(floor(end/2)+1:end);
        
        trasf2(1)=trasf2(1)/2;
        trasf2(end)=trasf2(end)/2;
        
        figure(3);
        set(gca, 'fontsize', 16)
        subplot(2,1,1)
        plot(freq2,abs(trasf2))
        grid on
        xlabel('freq [Hz]')
        ylabel('modulus')
        title('Fourier Transform')
        subplot(2,1,2)
        plot(freq2,angle(trasf2))
        grid on
        xlabel('freq [Hz]')
        ylabel('\phi [rad]')
        
        %% Plot on Real-Imaginary Plane
        
        figure(4)
        set(gca, 'fontsize', 16)
        plot(real(DFTterm),imag(DFTterm),'-*r')
        grid on
        xlabel('Re')
        ylabel('Im')
        xlim([-2 2])
        ylim([-1 1])
        
        %% Real and Imaginary part as function of the frequency
        
        figure (5)
        set(gca, 'fontsize', 16)
        subplot(2,1,1),plot(freq,real(DFTterm)),xlabel('freq [Hz]'),ylabel('Real')
        grid on
        subplot(2,1,2),plot(freq,imag(DFTterm)),xlabel('freq [Hz]'),ylabel('Imaginary')
        grid on
        %%
        figure (6)
        subplot(2,1,1)
        plot(freq4,abs(DFTterm4))
        grid on
        xlabel('freq [Hz]')
        ylabel('modulus')
        title('Fourier Transform (4k_m_i_n - 4k_m_a_x)')
        subplot(2,1,2)
        plot(freq4,angle(DFTterm4))
        grid on
        xlabel('freq [Hz]')
        ylabel('\phi [rad]')
        
        figure (5)
        figure (4)
        figure (3)
        figure (2)
        figure (1)
        
        
        
    end
end
%% Part 2

close all
[n p]=uigetfile('.mat','multiselect', 'on');
% a=load(n)
% load(n)

%% Different window

%Hanning
fsamp=100;             %%%% Sampling Frequency
N_wind=100;
sp_hann=hanning(N_wind);  %%%% hanning(N) :returns the N-point symmetric Hanning window in a column vector
zeroelemnt=zeros(1100,1);
spe_hann=[sp_hann;zeroelemnt];
long1=length(spe_hann);
T=long1/fsamp;
df_ha=1/T;
ft_spe_ha=fft(spe_hann);
spectrum_ha=[ft_spe_ha(long1/2+2:end);ft_spe_ha(1:long1/2+1)]/N_wind;
fre_ha=-fsamp/2+df_ha:df_ha:fsamp/2;

%flattop
sp_fl=window(@flattopwin,N_wind);
zeroelemnt=zeros(1100,1);
spe_fl=[sp_fl;zeroelemnt];
long1=length(spe_fl);
ft_spe_fl=fft(spe_fl);
spettro_fl=[ft_spe_fl(long1/2+2:end);ft_spe_fl(1:long1/2+1)]/N_wind;
fre_fl=-fsamp/2+df_ha:df_ha:fsamp/2;

% Rctangular
sp_ret=ones(N_wind,1);
zeroelemnt=zeros(1100,1);
spe_re=[sp_ret;zeroelemnt];
long1=length(spe_re);
ft_spe_re=fft(spe_re);
spettro_re=[ft_spe_re(long1/2+2:end);ft_spe_re(1:long1/2+1)]/N_wind;
fre_re=-fsamp/2+df_ha:df_ha:fsamp/2;

% Figures
figure
plot([0:1/fsamp:(long1-1)*1/fsamp],spe_re,'b','linewidth',2)
hold on
plot([0:1/fsamp:(long1-1)*1/fsamp],spe_hann,'r','linewidth',2)
plot([0:1/fsamp:(long1-1)*1/fsamp],spe_fl,'g','linewidth',2)
grid on
xlim([0 1.5]);
xlabel('t [s]')
ylabel('Amplitude')
legend('Rectangular','Hanning','Flat-top')
title('windows')
figure
plot(fre_re,abs(spettro_re),'b','linewidth',2)
grid on
hold on
plot(fre_ha,abs(spectrum_ha),'r','linewidth',2)
plot(fre_fl,abs(spettro_fl),'g','linewidth',2)
xlabel('\Deltaf [Hz]')
ylabel('Amplitude')
legend('Rectangular','Hanning','Flat-top')
title('windows')
xlim([-10 10]);

figure
semilogy(fre_re,abs(spettro_re),'b','linewidth',2)
hold on
semilogy(fre_ha,abs(spectrum_ha),'r','linewidth',2)
semilogy(fre_fl,abs(spettro_fl),'g','linewidth',2)
grid on
xlabel('\Deltaf [Hz]')
ylabel('Amplitude')
legend('Rectangular','Hanning','Flat-top')
title('windows')
xlim([-10 10]);
%%

for ii=1:length(n)
    load(cell2mat(n(ii)));
    dt=1/fsamp;
    N=length(y)
    T=N/fsamp;
    df=1/T;
    axis_t=0:dt:T-dt;
    fraz(ii)=N/10-floor(N/10)           %%%% Express the time shift from whole cycle
    rest=floor(N/2)-N/2                %%%% Investigation about even or odd number for scaling part
    figure
    plot(axis_t,y,'-o');
    xlabel('time [s]');
    ylabel('Signal');
    title(num2str(fraz(ii)))
    pause
    
    if rest==0 %even
        %rectangular
        ft_ret=fft(y);
        spectrum_ret(1)=ft_ret(1)/N;
        spectrum_ret(2:N/2)=2*ft_ret(2:N/2)./N;
        spectrum_ret(N/2+1)=ft_ret(N/2+1)/N;
        %hanning
        hann=hanning(N).';
        ft_han=fft(hann.*y);
        spectrum_han(1)=ft_han(1)/N;
        spectrum_han(2:N/2)=2*ft_han(2:N/2)./N;
        spectrum_han(N/2+1)=ft_han(N/2+1)/N;
        %flattop
        flatt=window(@flattopwin,N).';
        ft_flat=fft(flatt.*y);
        spectrum_flat(1)=ft_flat(1)/N;
        spectrum_flat(2:N/2)=2*ft_flat(2:N/2)./N;
        spectrum_flat(N/2+1)=ft_flat(N/2+1)/N;
        axis_f=0:df:fsamp/2;
        
        figure
        stem(axis_f,abs(spectrum_ret));
        xlabel('Frequency [Hz]')
        ylabel('|X|')
        hold on
        stem(axis_f,abs(spectrum_han),'r');
        stem(axis_f,abs(spectrum_flat),'g');
        legend('Rectangular','Hanning','Flat-top')
        
        %identification of the maximum in the spectra
        [pos_r val_r]=max(abs(spectrum_ret));
        p_r(ii)=pos_r;
        v_r(ii)=(val_r-1)*df;
        
        [pos_h val_h]=max(abs(spectrum_han));
        p_h(ii)=pos_h;
        v_h(ii)=(val_h-1)*df;
        
        [pos_f val_f]=max(abs(spectrum_flat));
        p_f(ii)=pos_f;
        v_f(ii)=(val_f-1)*df;
        
    else % odd
        
        %rectangular
        ft_ret=fft(y);
        spectrum_ret(1)=ft_ret(1)/N;
        spectrum_ret(2:(N+1)/2)=2*ft_ret(2:(N+1)/2)./N;
        %hanning
        hann=hanning(N).';
        ft_han=fft(hann.*y);
        spectrum_han(1)=ft_han(1)/N;
        spectrum_han(2:(N+1)/2)=2*ft_han(2:(N+1)/2)./N;
        %flattop
        flatt=window(@flattopwin,N).';
        ft_flat=fft(flatt.*y);
        spectrum_flat(1)=ft_flat(1)/N;
        spectrum_flat(2:(N+1)/2)=2*ft_flat(2:(N+1)/2)./N;
        axis_f=0:df:fsamp/2-df/2;
        
        figure
        stem(axis_f,abs(spectrum_ret));
        xlabel('Frequency [Hz]')
        ylabel('|X|')
        hold on
        stem(axis_f,abs(spectrum_han),'r');
        stem(axis_f,abs(spectrum_flat),'g');
        legend('Rectangular','Hanning','Flat-top')
        axis_f=0:df:fsamp/2-df/2;
        
        [pos_r val_r]=max(abs(spectrum_ret));
        p_r(ii)=pos_r;
        v_r(ii)=(val_r-1)*df;
        
        [pos_h val_h]=max(abs(spectrum_han));
        p_h(ii)=pos_h;
        v_h(ii)=(val_h-1)*df;
        
        [pos_f val_f]=max(abs(spectrum_flat));
        p_f(ii)=pos_f;
        v_f(ii)=(val_f-1)*df;
    end
    pause
    clear spectrum_flat spectrum_ret spectrum_han
end
%%
figure
plot(fraz,p_r,'o')
grid on
xlabel('\DeltaT_s')
ylabel('Maximum amplitude of the spectra')
title('Rectangular window')

figure
plot(fraz,p_h,'o')
grid on
xlabel('\DeltaT_s')
ylabel('Maximum amplitude of the spectra')
title('Hanning window')

figure
plot(fraz,p_f,'o')
grid on
xlabel('\DeltaT_s')
ylabel('Maximum amplitude of the spectra')
title('Flat-top window')

figure
plot(fraz,p_r,'o')
hold on
plot(fraz,p_h,'o')
hold on
plot(fraz,p_f,'o')
grid on
axis tight
grid on
xlabel('\DeltaT_s')
ylabel('Maximum amplitude of the spectra')
legend ('Rectangular window','Hanning window','Flat-top window')
title('Comparison')



% figure
% plot(fraz,v_r,'o')
% xlabel('Frazione di ciclo')
% ylabel('Frequenza del massimo dello spettro')
% title('Finestra rettangolare')
% figure
% plot(fraz,v_h,'o')
% xlabel('Frazione di ciclo')
% ylabel('Frequenza del massimo dello spettro')
% title('Finestra Hanning')
%
% figure
% plot(fraz,v_f,'o')
% title('flat top')
% title('rettangolare')
% xlabel('Frazione di ciclo')
% ylabel('Frequenza del massimo dello spettro')
% title('Finestra Flat-top')

