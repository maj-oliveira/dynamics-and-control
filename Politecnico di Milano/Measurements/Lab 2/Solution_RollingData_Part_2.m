clear
close all
clc
%% 
[name path]=uigetfile('*.mat','Select the file');
a=load([path,name]);
load([path,name]);
[r c]=size(Dati);

%%%%%% Applying the sensitiviy of the sensors to each channel
for jj=1:c
    Force(:,jj)=Dati(:,jj)/sens(jj);
end

dt=1/fsamp;
t=[0:dt:dt*(r-1)]';

figure;
for kk=1:c
    subplot(2,2,kk)
    plot(t,Force(:,kk))
    grid on
    axis tight
    xlabel('t [s]','Fontsize',12)
    ylabel('Force [kN]','Fontsize',12)
    title(['column ' num2str(kk)],'Fontsize',12)
end
%%

for jj=1:c
    t_initial=3;
    Mean_intial(jj)=mean(Force(1:t_initial/dt,jj));
    Force(:,jj)=Force(:,jj)-Mean_intial(jj);
end
%%
ch=input('Which channel do you want to analyse? ');

figure
plot(t,Force(:,ch))
xlabel('time [s]','Fontsize',15)
ylabel('Force [kN]','Fontsize',15)
grid on
axis tight

%%
Mean=mean(Force(:,ch));
devstd=std(Force(:,ch));
rms=sqrt(mean(Force(:,ch))^2+std(Force(:,ch))^2);
%%
it=input('Write lenght of the time window in which you want to calculate the travelling mean and RMS [s]: ');

N=it*fsamp;
Ngroup=floor(length(t)/N);

Meanf=zeros(1,Ngroup);
rmsf=zeros(1,Ngroup);

rrw=ones(1,Ngroup);
for ii=1:Ngroup
    sig_piece=Force((ii-1)*N+1:N*ii,ch);
    mf=mean(sig_piece);
    Meanf(ii)=mf;
    std_f(ii)=std(sig_piece);
    rmsf(ii)=sqrt(mf^2+std_f(ii)^2);
    rrw(ii)=rrw(ii)*ii;
end

TimeRms=rrw*it;

%%
figure
subplot(3,1,1)
plot(TimeRms,Meanf','LineWidth',2)
xlabel('time [s]','Fontsize',15)
ylabel('\mu [kN]','Fontsize',15)
line([TimeRms(1) TimeRms(end)],[Mean Mean],'LineStyle','--')
grid on
axis tight
legend(['Travelling window of ' num2str(it) ' s'],'whole signal')

subplot(3,1,2)
plot(TimeRms,std_f,'r','LineWidth',2)
xlabel('time [s]','Fontsize',15)
ylabel('\sigma [kN]','Fontsize',15)
line([TimeRms(1) TimeRms(end)],[devstd devstd],'LineStyle','--','color','r')
grid on
axis tight
legend(['Travelling window of ' num2str(it) ' s'],'whole signal')

subplot(3,1,3)
plot(TimeRms,rmsf','c','LineWidth',2)
xlabel('time [s]','Fontsize',15)
ylabel('\psi [kN]','Fontsize',15)
line([TimeRms(1) TimeRms(end)],[rms rms],'LineStyle','--','color','c')
grid on
axis tight
legend(['Travelling window of ' num2str(it) ' s'],'Whole signal')
