clear all
clc
V=load('21.3_32.3_250HzNew.txt'); %raw data in bites
t=(0:0.004:((0.004*length(V))-0.004))';% create time vector acording to 50 milisec delay 
beta=3560;
R25=220;
Vsmooth=smooth(V,15); %smooth signal
% plot(t,V);
% hold on
%plot(t,Vsmooth);
Volt=Vsmooth*5/4096; % amplified signal in Volts
Vther=3.034-(Volt/4.8771); %  Voltage on thermistor , gain is 1+38.5/9.93 
Rth=(174.7*Vther)./(5.038-Vther);
Tk=beta./(log(Rth/R25)+beta/298.15); %temp in kelvin
Tc=Tk-273.15;
t=t(1748:end);
t=(t-min(t))';
Tc=(Tc(1748:end))';

%Tc=a+(1-b*exp(c*t))+(1-d*exp(e*t))

% 
% myfittype = fittype('a*(1-b*exp(c*t))',...
%     'dependent',{'Tc'},'independent',{'t'},...
%     'coefficients',{'a','b','c'})
% myfit = fit(tfit,Tcfit,myfittype)
% plot(myfit,tfit,Tcfit)