% Function autospettro and cross spectrum:
% Auto / cross average spectrum, windowed and overlap 
%
% [Output, mediacomp, frequencies] = autocross (data1, data2, fsamp, SecPoints, overlap, Win);
%
% Data1, data2: time histories input
% Fsamp: sampling frequency
% SecPoints: Number of points in each subrecords that it has been used to divide the time history
% Overlap: overlap points
% Win: time window used to weight the data

function [autocross_mean,spectrum_mean,frequency,autocross]=autocross(data1,data2,fsamp,SecPoints,overlap,Win);

a=size(data1);
b=size(data2);

if a(2)>a(1)
    data1=data1';
end

if b(2)>b(1)
    data2=data2';
end


N=length(data1);
df=fsamp/SecPoints;

if (SecPoints/2)==(floor(SecPoints/2))
    frequency=0:df:(SecPoints/2*df);
else
    frequency=0:df:((SecPoints-1)/2)*df;
end

NF=length(frequency);

in=1;
NumPoint=0;
sum_complex=zeros(NF,1);
autocross=zeros(NF,1);

while NumPoint < N

    intial=(in-1)*(SecPoints-overlap)+1;
    
    LastNumPoint=intial+(SecPoints-1);
    
    spectrum1=fft_n(Win.*data1(intial:LastNumPoint),fsamp);
    
    sum_complex=sum_complex+spectrum1;
    
    spectrum2=fft_n(Win.*data2(intial:LastNumPoint),fsamp);
    
    autocross=autocross+conj(spectrum1).*spectrum2;
       
    in=in+1;
    NumPoint=LastNumPoint+SecPoints;

end

spectrum_mean=sum_complex./(in-1);
autocross_mean=(autocross./(in-1))./2;
