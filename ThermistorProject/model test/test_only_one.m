clear all;
%close all;
 Vard=4.97; % Arduino supply V
 beta=3560;
 R25=220;
 dt=0.004;
 fs=1/dt;
 fnorm=10/(fs/2);
 Vraw={load('23.3_34.5_250Hznew.txt'), load('22.8_35.7_250HzNewLong.txt'),...
 load('23.3_35_250Hznew.txt'),load('23.6_33.4_25Hznew.txt'),load('22.2_28.5_250HzNew.txt')...
 ,load('22.9_27.5_250HzNew.txt'),load('21.3_32.3_250HzNew.txt'),...
load('23.3_34.8_250HzNew.txt'),load('22.8_35.9_250HzNew.txt'),load('23_35.3_250HzNew.txt'),load('22.9_34.2_250HzNew.txt'),...
load('20.8_36.7_250HzNew.txt') };
% 
%  lpfilt = designfilt('lowpassfir','FilterOrder',200,'CutoffFrequency',fnorm);
% 
%  fvtool(lpfilt);
 
 %D = mean(grpdelay(lpfilt));

%Vfilt=filter(lpfilt,Vraw{:,2});
%%
 for i=5:5;
 V=[Vraw{:,i}]; 
 t=(0:dt:((dt*length(V))-dt));% create time vector acording to  milisec delay
   Vsmooth=smooth(V,20); %smooth signal
%  Vsmooth = filter(lpfilt,[V; zeros(D,1)]); % Append D zeros to the input data
%  Vsmooth = Vsmooth(D+1:end); 
 % Vsmooth=filtfilt(lpfilt,V(:));

 Volt=Vsmooth*3.3/4096; % amplified signal in Volts
 Vther=0.52-(Volt/9.4726); %  Voltage on thermistor , gain is 1+33/3.895 , potentiometer 0.52 V
 Rth=(2450*Vther)./(4.97-Vther); % arduino voltage 4.97 V
 Tk=beta./(log(Rth/R25)+beta/298.15); %temp in kelvin
 Tc=Tk-273.15;
 
%  figure (1)
%  plot(t,Volt);
%  hold on
%  title ('Output and Thermistor Voltage');
%  plot (t,Vther);
%  hold on
%  xlabel(' Time [sec]');
%  ylabel ('Amplitude [V]');
 %legend ( 'Vout' , 'Vther');
 figure (1)
 plot (t,Tc);
 hold on
 title('T centigrade');
 xlabel(' Time [sec]');
 ylabel ('Temperature [c]');
 figure (3)
 plot(t,Rth);
 title('Thermistor resistence Vs time');
 xlabel(' Time[sec]');
 ylabel ('Resistence[ohm]');
 hold on
 
 %preprocess for autofit
    %finding good starting point for fitting model
 figure(4)
 df=diff(Tc);
 plot(t,Tc,'.-k');
     ix=find(df==max(df));
     line(t(ix-25),Tc(ix-25),...
         'marker','o',...
         'markersize',10,...
         'markeredgecolor',[0,0,0],...
         'markerfacecolor',[1,1,1],...
         'linestyle','none');
 hold on

 figure(5)
 Tc_fit=Tc(ix-25:end);
 cuttail=t(ix-25);
 t_fit=t(ix-25:end)-cuttail;
 plot(t_fit,Tc_fit+273);
 xlim([0 80]);
 hold on

 
 
 %  


%  figure (6)
%  power=(Volt.^2./Rth);
% % power=smooth(power,20);
%  plot(t,power);
%  hold on
%  title 'power';


%  figure (4)
%  [X,f]=Frequency_Domain(V,250);
%  plot (f,X);
%  title ('freq');
%  hold on;
 end


