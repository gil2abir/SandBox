close all;

Vraw={load('20.5_25.5_500Hz.txt'), load('20.2_25.3_500Hz.txt'),load('20.7_26.6_1Khz.txt'),...
   load('20.8_27_1Kz.txt'),load('test 20_26.9_20Hz.txt')};
%Vnames= { '20.5-25.5 500Hz', '20.2-25.3 500Hz', '20.7-26.6 1KHz'...
    %'20.8-27 1KHz', '21.2_35_200hz'};
beta=3560;
R25=220;
Vard=[ 4.96 ,4.96 ,4.96 ,4.96 ,5.03 ];
Tfind=[ 0, 0,0,0,0];

for i=1:5
 V=[Vraw{:,i}];  
 if i<3
     dt=0.002;
    
 else if i<5
     dt=0.001;
    
 else
     dt=0.05;
 end    
 end    
 t=(0:dt:((dt*length(V))-dt));% create time vector acording to  milisec delay
 Vsmooth=smooth(V,20); %smooth signal
 Volt=Vsmooth*3.3/4096; % amplified signal in Volts
 Vther=3.016-(Volt/4.8771); %  Voltage on thermistor , gain is 1+38.5/9.93 , potentiometer 3.016 V
 Rth=(174.7*Vther)./(Vard(i)-Vther); % arduino voltage 4.96 V
 Tk=beta./(log(Rth/R25)+beta/298.15); %temp in kelvin
 Tc=Tk-273.15;
 figure (1)
 plot(t,Volt);
 hold on
 title ('Output and Thermistor Voltage');
 plot (t,Vther);
 hold on
 xlabel(' Time [sec]');
 ylabel ('Amplitude [V]');
 %legend ( 'Vout' , 'Vther');
 figure (2)
 plot (t,Tc);
 hold on
 title('T centigrade');
 xlabel(' Time [sec]');
 ylabel ('Temperature [c]');
 figure (3)
 plot(Tc,Rth);
 title('Thermistor resistence Vs Temperature');
 xlabel(' Temp[c]');
 ylabel ('Resistence[ohm]');
 hold on
 
 R25find=max(find(Rth>220));
 Tfind(i)=Tc(R25find);% these 2 lines make sure that R25 is 220 ohm at 25 c
 
 
end
%  figure
%  plot(tKhz,Rth);
  %R25find=max(find(Rth>220);
 % Tfind(i)=Tc(R25find);

%  
%  [a,b]=prepareCurveData(t,Tc);