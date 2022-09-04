close all
clear
clc

%%
[filename,path] = uigetfile;
cd(path)
load(filename)

%%
proxi_sync=proxi_sync/sens;
N=size(proxi_sync,2)
d_theta=2*pi/n_teeth;
theta_vec=0:d_theta:N*d_theta-d_theta;

%%
figure(1)
%set(gca, 'fontsize', 18)
plot(theta_vec,proxi_sync)
xlabel("Theta - angular position [rad]")
ylabel("displacement of the shaft [mm]")
title("Displacement of the shaft - synchronous sample")
axis tight
grid on

%% average position inside the shaft
average_position = mean(proxi_sync);
n_period=floor(length(proxi_sync)/n_teeth) %floor arredonda para baixo (Number of revolutions)
pos_ang1p=theta_vec(1:n_teeth);

summation_period=0;
Mean1=zeros(1,n_period);

figure(2)
hold on
for tt=1:n_period
    % mean of each selected section for one revolution
    Mean1(tt)=mean(proxi((tt-1)*n_teeth+1:tt*n_teeth)); 
    % Calculating sum of each section with respect to the others
    summation_period=summation_period+proxi((tt-1)*n_teeth+1:tt*n_teeth)-Mean1(tt);             
    % Plot each single section in one figure
    
    %plot((2*pi/72)*(0:71),proxi((tt-1)*n_teeth+1:tt*n_teeth)-Mean1(tt),'b')
end
%%
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
figure(2)
set(gca, 'fontsize', 18)
hold on
grid on
plot(pos_ang1p,averaged_period,'r','linewidth',2)
ylabel('displacement [mm]','fontsize',16)
xlabel('angular position [rad]','fontsize',16)
axis tight