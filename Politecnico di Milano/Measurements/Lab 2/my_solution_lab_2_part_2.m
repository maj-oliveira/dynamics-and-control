close all
clear
clc

%% load the data
[filename, path] = uigetfile
cd(path)
load(filename)

%% pre calculations
n_signals = size(Dati,2);
Dati=Dati./sens';
dt=1/fsamp;
time=0:dt:size(Dati,1)*dt-dt;

%% plot in time domain
for i=1:n_signals
    subplot(n_signals,1,i)
    plot(time,Dati(:,i))
    grid on
    xlabel("time")
    ylabel("kN")
    title("signal"+i)
end

%% mean, std and rms for 1 column
my_mean = mean(Dati)
my_std = std(Dati)
my_rms = rms(Dati)

%% travelling window of 1s

for i=1:1:size(Dati,1)-fsamp
    mean_window(i) = mean(Dati(i:i+fsamp,1));
    std_window(i) = std(Dati(i:i+fsamp,1));
    rms_window(i) = rms(Dati(i:i+fsamp,1));
end

max_mean = max(mean_window)
max_std = max(std_window)
max_rms = max(rms_window)

%if we want to analyse the avarage force, we should despise the transiet
%behavior. We can represent only the dynamic part when we are in the
%transient phase.