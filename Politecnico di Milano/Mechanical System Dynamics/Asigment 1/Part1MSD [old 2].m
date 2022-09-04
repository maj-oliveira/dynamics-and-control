clear all
clc
close all

%% load data
disp('load DH1');
[name path] = uigetfile('*.mat');
load(name);

% disp('load DH2');
% [name path] = uigetfile('*.mat',);
% load(name);
% 
% disp('load RH1');
% [name path] = uigetfile('*.mat',);
% load(name);

%% Variables

L=1200; %mm
h=8; %mm
b=40; %mm
ro=2700; %kg/m^3
E=68*10^9; %Pa
senshammer = 2.17; %mV/N
sensacc = 100; %mV/g
A1 = 105; %mm
A2 = 415;
A3 = 600;
DH1 = 815;
DH2 = 1065;
g = 9.8; %m/s^2
m = L*h*b*ro*(10^-9); %kg/m
J = b*(h^3)*(10^-12)/12 ; %m^4

FRF = (frf.*g)./sensacc;
modulus = abs(FRF);
phase = angle(FRF);


%% Plot
titlemod={'Modulus A1', 'Modulus A2', 'Modulus A3'};
titlephase={'Phase A1', 'Phase A2', 'Phase A3'};

figure()
for i=1:3
    subplot(2,3,i)
    plot(freq,modulus(:,i));
    xlabel('frequency [Hz]');
    ylabel('Amplitude [m/s^2]');
    title(titlemod(i));
end

for i=1:3
    subplot(2,3,i+3)
    plot(freq,phase(:,i));
    xlabel('frequency [Hz]');
    ylabel('Phase [rad]');
    title(titlephase(i));
end


%% Natural Frequencies

%findpeaks(modulus(:,1),'MinPeakDistance',2500,'MinPeakProminence',4)

[pks1 loc1]=findpeaks(modulus(:,1),'MinPeakProminence',11);
findpeaks(modulus(:,1),'MinPeakProminence',11);

%A1
for i=1:length(loc1)
    natural_freq1(i)=freq(loc1(i));
end

%A2
[pks2 loc2]=findpeaks(modulus(:,2),'MinPeakProminence',11);
findpeaks(modulus(:,2),'MinPeakProminence',11);

for i=1:length(loc2)
    natural_freq2(i)=freq(loc2(i));
end

%A3
[pks3 loc3]=findpeaks(modulus(:,3),'MinPeakProminence',11);
findpeaks(modulus(:,3),'MinPeakProminence',11);

for i=1:length(loc3)
    natural_freq3(i)=freq(loc3(i));
end

disp(natural_freq1);
disp(natural_freq2);
disp(natural_freq3);

natural_freq=[natural_freq1(1) natural_freq1(2) natural_freq3(2) natural_freq1(3) natural_freq1(4)]

%% damping ratio slope of the phase method

e=1;
delta = (freq(2)-freq(1))*e;

d1=(phase(loc1(1)+e,1)-phase(loc1(1)-e,1))/(2*delta);
damping_ratio_1=-1/(natural_freq(1)*d1)

d2=(phase(loc1(2)+e,1)-phase(loc1(2)-e,1))/(2*delta);
damping_ratio_2=-1/(natural_freq(2)*d2)

d3=(phase(loc3(2)+e,3)-phase(loc3(2)-e,3))/(2*delta);
damping_ratio_3=-1/(natural_freq(3)*d3)

d4=(phase(loc1(3)+e,1)-phase(loc1(3)-e,1))/(2*delta);
damping_ratio_4=-1/(natural_freq(4)*d4)

d5=(phase(loc1(4)+e,1)-phase(loc1(4)-e,1))/(2*delta);
damping_ratio_5=-1/(natural_freq(5)*d5)

%% damping ratio half-power points method

delta = 10;
half_power_1 = modulus(loc1(1),1)*sqrt(2)/2;
for i=(loc1(1)-50):loc1(1)
    delta_comp = abs(modulus(i,1) - half_power_1);
    if delta_comp<delta
       delta = delta_comp;
       w1_1 = freq(i);
    end
end
delta = 10;
for i=loc1(1):(loc1(1)+50)
    delta_comp = abs(modulus(i,1) - half_power_1);
    if delta_comp<delta
       delta = delta_comp;
       w2_1 = freq(i);
    end
end

h_1 = (w2_1^2 - w1_1^2)/(4*natural_freq1(1).^2)


delta = 10;
half_power_2 = modulus(loc1(2),1)*sqrt(2)/2;
for i=(loc1(2)-50):loc1(2)
    delta_comp = abs(modulus(i,1) - half_power_2);
    if delta_comp<delta
       delta = delta_comp;
       w1_2 = freq(i);
    end
end
delta = 10;
for i=loc1(2):(loc1(2)+50)
    delta_comp = abs(modulus(i,1) - half_power_2);
    if delta_comp<delta
       delta = delta_comp;
       w2_2 = freq(i);
    end
end
h_2 = (w2_2^2 - w1_2^2)/(4*natural_freq1(2).^2)


delta = 10;
half_power_3 = modulus(loc3(2),3)*sqrt(2)/2;
for i=(loc3(2)-50):loc3(2)
    delta_comp = abs(modulus(i,3) - half_power_3);
    if delta_comp<delta
       delta = delta_comp;
       w1_3 = freq(i);
    end
end
delta = 10;
for i=loc3(2):(loc3(2)+50)
    delta_comp = abs(modulus(i,3) - half_power_3);
    if delta_comp<delta
       delta = delta_comp;
       w2_3 = freq(i);
    end
end

h_3 = (w2_3^2 - w1_3^2)/(4*natural_freq(3).^2)


delta = 10;
half_power_4 = modulus(loc1(3),1)*sqrt(2)/2;
for i=(loc1(3)-50):loc1(3)
    delta_comp = abs(modulus(i,1) - half_power_4);
    if delta_comp<delta
       delta = delta_comp;
       w1_4 = freq(i);
    end
end
delta = 10;
for i=loc1(3):(loc1(3)+50)
    delta_comp = abs(modulus(i,1) - half_power_4);
    if delta_comp<delta
       delta = delta_comp;
       w2_4 = freq(i);
    end
end
h_4 = (w2_4^2 - w1_4^2)/(4*natural_freq1(3).^2)


delta = 10;
half_power_5 = modulus(loc1(4),1)*sqrt(2)/2;
for i=(loc1(4)-50):loc1(4)
    delta_comp = abs(modulus(i,1) - half_power_5);
    if delta_comp<delta
       delta = delta_comp;
       w1_5 = freq(i);
    end
end
delta = 10;
for i=loc1(4):(loc1(4)+50)
    delta_comp = abs(modulus(i,1) - half_power_5);
    if delta_comp<delta
       delta = delta_comp;
       w2_5 = freq(i);
    end
end
h_5 = (w2_5^2 - w1_5^2)/(4*natural_freq1(4).^2)

%% Part 2

for omega = 0:1:3141
 L=L/1000;
 y = (m*(omega^2)/(E*J))^(1/4);
    
    G=[0 -1 0 1;
      -1 0 1 0;
      sin(y*L) -cos(y*L) sinh(y*L) cosh(y*L);
      -cos(y*L) -sin(y*L) cosh(y*L) sinh(y*L)];
 
     vet_det(omega+1) = det(G);

end


%% Plot G
figure
omega = 0:1:500*2*pi;
plot(omega,vet_det)
