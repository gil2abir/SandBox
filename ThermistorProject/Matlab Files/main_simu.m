

%%
%set thermistor parameters in struct, with dialoge window.
% prompt={' R25', 'tau' ,'beta','d.c'};
% therminput=inputdlg(prompt)
% therm.R25=str2num(therminput{1});
% therm.tau=str2num(therminput{2});  %time contant of thermistor , [sec]
% therm.beta=str2num(therminput{3}); % beta coeficient of themistor , [K]
% therm.dc=str2num(therminput{4});  % disipation contant , [W/dC]

%%
%set thermistor parameters in struct.
Vin=[3.3 5 9 15 30] ;
therm.R25=220 ;%resistence at 25 deg centigrade, [ohm]
therm.tau=15 ;  %time contant of thermistor , [sec]
therm.beta=3560 ; % beta coeficient of themistor , [K]
therm.dc=8.5e-3 ; % disipation contant , [W/dC]

R=1/therm.dc ; % dC/W  
c=therm.tau/R; %J/dC

%set temp, current and time vectors for loop

dt=0.0002; % time step , sec
t=0:dt:35;
Imax=Vin./therm.R25 ; % A , calculated by V/R where V=5v R=R0
lt = length(t);
T0=298; % initial temp K
T=ones(lt,1)*T0;
T1=ones(lt,1)*T0;
Rth=ones(lt,1)*therm.R25; %thermistor 
V=zeros(lt,1);
I=zeros(lt,1);
Ta=310; % ambient temp
T_NoCon=Ta+(T0-Ta).*exp(-1/therm.tau);
figure 
plot(t,T_NoCon,'.')
hold on
%%
for j=1:length(Imax);
for n=2:lt
%n=2;
% while Ta-T(n-1)>0.1 && n<=lt
 T(n)=TempOfThermistor(I(n-1),T(n-1),Rth(n-1),Ta,R,c,dt);
 Rth(n)=ThermistorResistence(T(n),therm.R25,therm.beta);
 I(n)=ThermCurrent(T(n),T(n-1),Rth(n),c,Imax(j),dt);
 V(n)=I(n)*Rth(n);
% n=n+1; 
plot(t,T);
title('T(t)');
xlabel('t[sec]');
ylabel('T[K]');
hold on
end
end
 
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
