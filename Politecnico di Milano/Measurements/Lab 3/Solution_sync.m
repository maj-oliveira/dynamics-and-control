%%%%% Code for analyzing the synchronous sampling

close all
clear
clc

%% Load

[name PathFile]=uigetfile();
                                                                           % proxi_sync: [1x101952 double]
load([PathFile name])                                                      % sens: 8
                                                                           % Note: 'Sensibility in V/mm'
                                                                           % n_teeth: 72
%% Calibration

proxi=proxi_sync/sens;
N=length(proxi_sync);

d_theta=2*pi/n_teeth;
% instead of the time vector define angular position vector
theta_vec=0:d_theta:N*d_theta-d_theta;

%% Plot the displacement versus position in radian 

figure
set(gca, 'fontsize', 18)
plot(theta_vec,proxi)
grid on
ylabel('displacement [mm]','fontsize',16)
xlabel('angular position [rad]','fontsize',16)
axis tight

%% Time averaging

% # periods
%%%%% Specify the number of sections of the signal for averaging part

n_period=floor(length(proxi)/n_teeth);  % Number of sections (Number of revolutions)
                                                 
pos_ang1p=theta_vec(1:n_teeth);  % Specifying the angular position in one revolution

summation_period=0;
Mean1=zeros(1,n_period);

figure(3)
hold on
for tt=1:n_period
    % mean of each selected section for one revolution
    Mean1(tt)=mean(proxi((tt-1)*n_teeth+1:tt*n_teeth)); 
    % Calculating sum of each section with respect to the others
    summation_period=summation_period+proxi((tt-1)*n_teeth+1:tt*n_teeth)-Mean1(tt);             
    % Plot each single section in one figure
    plot((2*pi/72)*(0:71),proxi((tt-1)*n_teeth+1:tt*n_teeth)-Mean1(tt),'b')
end

% Time averaging
% Calculating the average for n_period number sections(each section contains a revolution)
averaged_period=summation_period/n_period;                                                                         

% Plotting the calculated mean value vs different sections(number of revolution)
figure
grid on
set(gca, 'fontsize', 18)
plot(1:n_period,Mean1)                                                           
ylabel('mean [mm]','fontsize',16)
xlabel('period','fontsize',16)

% plot the average value for all sections
figure(3)
set(gca, 'fontsize', 18)
hold on
grid on
plot(pos_ang1p,averaged_period,'r','linewidth',2)
ylabel('displacement [mm]','fontsize',16)
xlabel('angular position [rad]','fontsize',16)
axis tight


