close all
clear
clc

%% rms limits by legislation:
a_ref=1e-6; %m/s^2
a_lim_H=87; %dB
a_lim_V=89; %dB

%% 0 - Loading and displaying data

[filename, pathname]=uigetfile;


cd(pathname);

load(filename);


n_signals=size(data,2);

disp(['There are ' num2str(n_signals) ' signals in the loaded file'])

dt=1/fsamp;

for ii=1:n_signals
    data(:,ii)=data(:,ii)/sens(ii);
end

N=size(data,1);

time=0:dt:N*dt-dt;

figure;

for ii=1:n_signals
    
    subplot(n_signals,1,ii)
    
    plot(time,data(:,ii))
    
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    grid on
    legend({char(channel_name(ii))},'Interpreter', 'none')
    
end

%% 1 - Calculate the root mean square value of the signal of a 60s record;

STD=std(data);
MEAN=mean(data);
RMS_tot=sqrt(MEAN.^2+STD.^2);
RMS_tot_db=20*log10(RMS_tot/a_ref);

%%%%% displaying the rms limits by legislation:
disp('RMS limits of the Standard UNI:')
disp(['RMS Horizontal limit: ' num2str(a_lim_H) ' dB']);
disp(['RMS Vertical limit: ' num2str(a_lim_V) ' dB']);

%%%%% displaying the calculated rms:
disp(' ')
disp('RMS on the whole record')
disp(['rms x-axis: ' num2str(RMS_tot_db(1)) ' dB']);
disp(['rms y-axis: ' num2str(RMS_tot_db(2)) ' dB']);
disp(['rms z-axis: ' num2str(RMS_tot_db(3)) ' dB']);

%% 2 - Calculate the signal Crest Factor
for ii=1:n_signals
    cf(ii)=max(abs(data(:,ii)-MEAN(ii)))./RMS_tot(ii);
end

%%%%% Displaying the crest factor for each signal 
disp(' ')
disp('Crest factor')
disp(['cf x-axis: ' num2str(cf(1))]);
disp(['cf y-axis: ' num2str(cf(2))]);
disp(['cf z-axis: ' num2str(cf(3))]);

pause
%% 4 - If the crest factor is higher than 6 calculate the RMS on a 
% travelling window of 1s and compare the maximum RMS value 
% with the limit of the standard;

RMS0=zeros(floor(length(data)/fsamp),3);
for ii=1:length(RMS0)
    RMS0(ii,:)=rms(data((ii-1)*fsamp+1:(ii)*fsamp,:));
end
RMS_db=20*log10(RMS0/a_ref);

figure
subplot(3,1,1)
plot(RMS_db(:,1),'LineWidth',2),grid on,hold on
plot([0 length(RMS_db(:,1))],[a_lim_H a_lim_H],'r')
ylabel('rms [dB]')
title('x-axis')
subplot(3,1,2)
plot(RMS_db(:,2),'LineWidth',2),grid on,hold on
plot([0 length(RMS_db(:,2))],[a_lim_H a_lim_H],'r')
ylabel('rms [dB]')
title('y-axis')
subplot(3,1,3)
plot(RMS_db(:,3),'LineWidth',2),grid on,hold on
plot([0 length(RMS_db(:,3))],[a_lim_V a_lim_V],'r')
ylabel('rms [dB]')
title('z-axis')

pause 
%% Evaluate the signal to noise ratio of the given signal and check that it is higher than 10 dB

figure
plot(data(:,3)),grid on
title('Select an area with just noise')
axis tight

[x1 y1]=ginput(2);             %%%%%%Select the range of noisy part 

title('Select an area with signal and noise')

[x2 y2]=ginput(2);             %%%%%%Select the range of noisy part and the signal part

s2n=20*log10(rms(data(floor(x2(1)):floor(x2(2)),:))./rms(data(floor(x1(1)):floor(x1(2)),:)));

disp(' ')
disp('Signal to noise ratio')
disp(['s2n x-axis: ' num2str(s2n(1))]);
disp(['s2n y-axis: ' num2str(s2n(2))]);
disp(['s2n z-axis: ' num2str(s2n(3))]);
