close all;
clear all;

%set thermistor parameters in struct, with dialoge window.
% prompt={' R25', 'tau' ,'beta','d.c'};
% therminput=inputdlg(prompt)
% therm.R25=str2num(therminput{1});
% therm.tau=str2num(therminput{2});  %time contant of thermistor , [sec]
% therm.beta=str2num(therminput{3}); % beta coeficient of themistor , [K]
% therm.dc=str2num(therminput{4});  % disipation contant , [W/dC]


%set thermistor parameters in struct.
Vin=[5,9,15,30,50];
therm.R25=220;%resistence at 25 deg centigrade, [ohm]
therm.tau=15 ;  %time contant of thermistor , [sec]
therm.beta=3560 ; % beta coeficient of themistor , [K]
therm.dc=8.5e-3 ; % disipation contant , [W/dC]

R=1/therm.dc ; % dC/W  
c=therm.tau/R; %J/dC

%set temp, current and time vectors for loop
ltv=length(Vin);
dt=0.0002; % time step , sec
t=0:dt:35;
Imax=Vin./therm.R25 ; % A , calculated by V/R where V=5v R=R0
lt = length(t);
T0=298; % initial temp K
T=ones(lt,ltv)*T0;
T1=ones(lt,ltv)*T0;
Rth=ones(lt,ltv); %thermistor 
V=zeros(lt,ltv);
I=zeros(lt,ltv);

Ta=310; % ambient temp

for j=1:ltv

    for n=2:lt
%n=2;
% while Ta-T(n-1)>0.1 && n<=lt
 
 Rth(n,j)=ThermistorResistence(T(n-1,j),therm.R25,therm.beta);
 T(n,j)=TempOfThermistor(I(n-1,j),T(n-1,j),Rth(n,j),Ta,R,c,dt);
 I(n,j)=ThermCurrent(T(n,j),T(n-1,j),Rth(n,j),c,Imax(j),dt);
 V(n,j)=I(n,j)*Rth(n,j);
% n=n+1; 
end
%SI(j)=stepinfo(T(:,j),t,310);
 %subplot(2,2,1); 
plot(t,T(:,j));
title('Temp vs Time , differnt Vin');
xlabel('t[sec]');
ylabel('T[K]');
hold on
% subplot(2,2,2);
% plot(t,Rth(:,j));
% title('Rt(t)');
% hold on
% subplot(2,2,3);
% hold on
% plot(t,V(:,j));
% title('V(t)');
% hold on
% subplot(2,2,4);
% plot(t,I(:,j));
% hold on;
% title('I(t)');
% xlabel('t[sec]');
% ylabel('I[A]');
end

%  figure
%  plot (Vin,tc);
%  title 'Time constant vs Vin'

% subplot(2,2,1); 
% plot(t,T);
% title('T(t)');
% xlabel('t[sec]');
% ylabel('T[K]');
% hold on
% subplot(2,2,2);
% plot(t,Rth);
% title('Rt(t)');
% subplot(2,2,3);
% plot(t,V);
% title('V(t)');
% subplot(2,2,4);
% plot(t,I);
% title('I(t)');
% xlabel('t[sec]');
% ylabel('I[A]');
