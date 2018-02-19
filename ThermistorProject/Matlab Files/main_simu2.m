close all
clear all

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
Vin=[5 9 15 30] ;
R25=220 ;%resistence at 25 deg centigrade, [ohm]
tau=15 ;  %time contant of thermistor , [sec]
beta=3560 ; % beta coeficient of themistor , [K]
dc=8.5e-3 ; % disipation contant , [W/dC]

R=1/dc ; % dC/W
c=tau/R; %J/dC

%set temp, current and time vectors for loop

dt=0.001; % time step , sec
t=0:dt:40;
Imax=Vin./R25 ; % A , calculated by V/R where V=5v R=R0
lt = length(t);
T0=298; % initial temp K
T=ones(lt,1)*T0;
T1=ones(lt,1)*T0;
Rth=ones(lt,1)*R25; %thermistor
V=zeros(lt,1);
I=zeros(lt,1);
Ta=310; % ambient temp
T_NoCon=Ta+(T0-Ta).*exp(-t/tau);
Ttau=(T0+0.63*(Ta-T0));
figure
plot(t,T_NoCon)
hold on
%%
ttau=zeros(length(Imax)+1,1);
for j=1:length(Imax);
    flag=1;
    for n=2:lt
        
        %n=2;
        % while Ta-T(n-1)>0.1 && n<=lt
        Rth(n)=ThermistorResistence(T(n-1),R25,beta);
        T(n)=TempOfThermistor(I(n-1),T(n-1),Rth(n),Ta,R,c,dt);
        %Rth(n)=ThermistorResistence(T(n),R25,beta);
        I(n)=ThermCurrent(T(n),T(n-1),Rth(n),c,Imax(j),dt);
        V(n)=I(n)*Rth(n);
        if flag==1;
          if T(n)>Ttau
            flag=0;
            ttau(j)=t(n);
          end
        end 
    end
    figure (1)
    plot(t,T);
    title('T(t)');
    xlabel('t[sec]');
    ylabel('T[K]');
    hold on
    figure (2)
    plot (t,I);
    hold on
end
figure (1)
ttau(j+1)=15;
Ttaus=ones(j+1,1)*Ttau;
plot(ttau,Ttaus,'.');


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
