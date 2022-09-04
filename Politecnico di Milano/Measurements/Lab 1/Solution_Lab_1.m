close all
clear
clc

%% 1 - Display a dialog window to choose the file to open

[filename, pathname]=uigetfile;

%% 2 - Load the file

cd(pathname);

load(filename);

%% 3 - Define how many signals there are in the loaded file

n_signals=size(Data,2);

disp(['There are ' num2str(n_signals) ' signals in the loaded file'])


%% 4 - Derive the sampling time dt knowing the sampling frequency

dt=1/fsamp;
disp(['The sampling time "dt" is: ' num2str(dt) ' s'])

%% 5 - Transform the signals in engineering units (EU) using the accelerometers senitivity values; 

for ii=1:n_signals
    Data(:,ii)=Data(:,ii)/sens(ii);
end

%% 6 - Build the time axis using a for loop (for)  and defining directly the time vector

N=size(Data,1);

for ii=1:1:N
    time1(ii)=(ii-1)*dt;
end

time=0:dt:N*dt-dt;

%% 7/8 - Plot the signals in the time domain and display on the graphs a grid, the legend and the axis title

figure;

for ii=1:n_signals
    
    subplot(n_signals,1,ii)
    
    plot(time,Data(:,ii))
    
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    grid on
    legend([(channels{ii}) ' direction'])
%     axis tight
end

%% 9 Calculates the maximum (using max  and a recursive cycle), the minimum (min), the mean (mean), the standard deviation (std) and the RMS value for all the channels.


MAX=max(Data);
MIN=min(Data);
MEAN=mean(Data);
STD=std(Data);

MAX_rec=[0 0];

for kk=1:n_signals
    for ii=1:N
        if ii==1
            MAX_rec(1,kk)=Data(ii,kk);
        else
            if Data(ii,kk)>MAX_rec(1,kk)
                MAX_rec(1,kk)=Data(ii,kk);
            end
        end
    end
end


RMS=sqrt(MEAN.^2+STD.^2);                                                   %%%%% calculating rms using mean and standard deviation
RMS2=sqrt(sum((Data.^2))/N);                                             %%%%% calculating rms using sum of the square of data devide to number of samples


for ii=1:n_signals
    
    disp(['Signal ' num2str(ii) ':'])
    disp(['Maximum: ' num2str(MAX(ii)) ' m/s^2'])
    disp(['Minimum: ' num2str(MIN(ii)) ' m/s^2'])
    disp(['Mean: ' num2str(MEAN(ii)) ' m/s^2'])
    disp(['Standard deviation: ' num2str(STD(ii)) ' m/s^2'])
    disp(['RMS: ' num2str(RMS(ii)) ' m/s^2'])
    
end

if MAX_rec==MAX
    disp('The two values for the maximum of the signals coincide')
else
    disp('ERROR')
end


%% 10 - Display on the time histories plot the values calculated in the previous point as lines

figure;

for ii=1:n_signals
    
    subplot(n_signals,1,ii)
    plot(time,Data(:,ii))
    hold all
    
    line([0 time(end)],[MIN(ii) MIN(ii)],'Linewidth',1,'color','g')
    line([0 time(end)],[MAX(ii) MAX(ii)],'Linewidth',1,'color','m')
    line([0 time(end)],[RMS(ii) RMS(ii)],'Linewidth',2,'color','y')
    
    legend([(channels{ii}) ' direction'],['Maximum value: ' num2str(MAX(ii)) ' m/s^2'],['Minimum value: ' num2str(MIN(ii)) ' m/s^2'],['RMS: ' num2str(RMS(ii)) ' m/s^2']);
    axis tight
    
end

%% 11 - Save in a text file (*.txt) all the values of the quantities calculated at point

save('stat.txt','-ascii','-double','-tabs','MEAN','MIN','MAX','STD','RMS'); %%%% saving the computed amounts in a .txt file