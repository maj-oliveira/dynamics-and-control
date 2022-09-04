clear
close all
clc

%% Load

[name folder]=uigetfile();

load([folder name])

%% Calibration

ref=ref/sens;
proxi=proxi/sens;

%% Building the TIME axis
N=length(proxi);
dt=1/fsamp;
time=0:dt:N/fsamp-dt;

%% Plot

figure
set(gca, 'fontsize', 18)
plot(time,proxi)% Plot the displacement of one proxy meter results (displacement mm)
grid on
ylabel('displacement [mm]','fontsize',16)
xlabel('time [s]','fontsize',16)
axis tight

figure
set(gca, 'fontsize', 18)
plot(time,ref)% Plot the displacement of the reference proxy meter sensor results  
grid on
ylabel('reference','fontsize',16)
xlabel('time [s]','fontsize',16)
axis tight

%% Find the peaks

pos_peaks=find(ref>2); % Find the peaks position in reference signal 
Period=diff(time(pos_peaks)); % Find the time diffetence between peaks (we find that it is a periodic phenomena) 
hold on
plot(time(pos_peaks),ref(pos_peaks),'or') % Plot these maximum points
axis tight

%  # of points of the first period

npt_per=pos_peaks(2)-pos_peaks(1); % the length of first period (distance between two peaks)

%% Plot of the first 15 periods to see if they are equal 

figure
set(gca, 'fontsize', 18)
hold on
grid on
colors=['r','b','g','r','b','g','r','b','g','r','b','g','r','b','g'];

for tt=1:15

    plot((tt-1)*npt_per+1:tt*npt_per,proxi((tt-1)*npt_per+1:tt*npt_per),colors(tt))
    axis tight
%     pause
    
end
%% Time averaging  (Calculate the average for each revolution)

% time for the first period

time1p=time(1:npt_per);

summation_period=0;

% # of periods
n_periods=floor(length(proxi)/npt_per);                                    % Calculating the total number of periodic sections

mean_vec=zeros(1,n_periods);

for tt=1:n_periods
   % Calculating mean for each section
   mean_vec(tt)=mean(proxi((tt-1)*npt_per+1:tt*npt_per));   
   % Caculating the sum of sections
   summation_period=summation_period+proxi((tt-1)*npt_per+1:tt*npt_per)-mean_vec(tt);         
end

% time averaging
averaged_period=summation_period/n_periods;

% plot
figure
set(gca, 'fontsize', 18)
hold on
grid on
plot(1:n_periods,mean_vec)                                                 % Plotting the mean values for different periodic sections
xlabel('periods','fontsize',16)
ylabel('mean value on the period [mm]','fontsize',16)
axis tight

figure
set(gca, 'fontsize', 18)
hold on
grid on
plot(time1p,averaged_period,'r','linewidth',2)                             % Plotting the average of all different periodic sections
ylabel('displacement [mm]','fontsize',16)
xlabel('time [s]','fontsize',16)
plot(time1p,proxi(1:npt_per)-mean_vec(1))% Plotting the displacement for the first periodic sections
%Plotting the displacement for the last periodic section
plot(time1p,proxi(((n_periods-1)*(npt_per)+1):(n_periods)*(npt_per))-mean_vec(1),'.-c')  
legend('Time averaging','First period','Last period')

