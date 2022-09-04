close all %close all figures
clear %remove variables from workspace
clc %clear command window
%% load data
[filename, path] = uigetfile;
cd(path)
load(filename)
%% 
n_signals = size(data,2)
dt = 1/fsamp

for i=1:1:n_signals
    data(:,i)=data(:,i)/sens(i);
end

%% plot data in time domain
time = 0:dt:size(data,1)*dt-dt;
figure(1)
plot(time,data(:,1))

%% means, std and rms

mean_signal = mean(data)    
std_signal = std(data)
rms = sqrt(mean_signal.^2+std_signal.^2)

%% max value and crest factor

for i=1:1:n_signals
   max_signal(i)=data(1,i);
   for j=1:1:size(data,1)
        if max_signal(i)<data(j,i)
            max_signal(i)=data(j,i);
        end
   end
end

CF=max_signal./rms

%% travelling window

max_rms=[-10000000,-10000000,-10000000];
for i=1:1:size(data,1)-fsamp
    mean_window = mean(data(i:fsamp+i,:));
    std_window = std(data(i:fsamp+i,:));
    rms_window = sqrt(mean_window.^2+std_window.^2);
   for j=1:1:3
    if max_rms(j)<rms_window(j)
        max_rms(j)=rms_window(j);
    end
   end
end

%% rms in db

rms_db = 20*log10(rms./10^(-6))
max_rms_db = 20*log10(max_rms./10^(-6))
