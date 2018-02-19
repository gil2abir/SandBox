clear all 
close all
Vin=5 ; %[5 9 15 30] ;
R25=220 ;%resistence at 25 deg centigrade, [ohm]
tau=12 ;  %time contant of thermistor , [sec]
beta=3560 ; % beta coeficient of themistor , [K]
dc=8.5e-3 ; % disipation contant , [W/dC]
Rt=(1/dc)/2;
Ct=tau*dc/2;

r1=0.9*(Rt/2);
r2=0.3*(Rt/2);       
c1=0.95*Ct;
c2=0.35*Ct;


a=r1*r2*c1*c2;
b=r2*c2+r1*c1+c1*r2;
c=r1*r2*c2;
d=r1+r2;

m1=-(-b/a+sqrt((b/a)^2-(4/a)))*0.5;
m2=-(-b/a-sqrt((b/a)^2-(4/a)))*0.5;
% m1=r1*c1;
% m2=r2*c2;


%set temp, current and time vectors for loop

dt=0.001; % time step , sec
t=0:dt:70;
Imax=Vin./R25 ; % A , calculated by V/R where V=5v R=R0
lt = length(t);
T0=298; % initial temp K
T=ones(lt,1)*T0;
T_noCon=T;
Tmod1=T;
Rth=ones(lt,1)*R25;%thermistor
RthNo=Rth;
V=zeros(lt,1);
I=zeros(lt,1);
Imod1=I;
Ta=310; % ambient temp

%Ttau=(T0+0.63*(Ta-T0));
a1=((Ta-T0)/a)*((1/(m2-m1))/m1);
a2=((Ta-T0)/a)*((1/(m1-m2))/m2);
T_NoCon1=a1*(1-exp(-m1*t))+a2*(1-exp(-m2*t))+298;
T_NoCon2=Ta+(T0-Ta).*exp(-t/tau);
figure (1)
plot(t,T_NoCon1)
hold on
plot(t,T_NoCon2)
legend('no con 2nd','no con 1st');


%%
ttau=zeros(length(Imax)+1,1);
for j=1:length(Imax);
    flag=1;
    for n=3:lt
        
        T_noCon(n)=TempOfTherm2(a,b,c,d,dt,0,0,RthNo(n-1),RthNo(n-2),T_noCon(n-1),T_noCon(n-2),Ta);
        T(n)=TempOfTherm2(a,b,c,d,dt,I(n-1),I(n-2),Rth(n-1),Rth(n-2),T(n-1),T(n-2),Ta);
        Tmod1(n)=TempOfTherm2(a,b,c,d,dt,Imod1(n-1),Imod1(n-2),Rth(n-1),Rth(n-2),Tmod1(n-1),Tmod1(n-2),Ta);
        Rth(n)=ThermistorResistence(T(n),R25,beta);
        RthNo(n)=ThermistorResistence(T_noCon(n),R25,beta);
        I(n)= current2(a,b,c,d,T(n),T(n-1),T(n-2),I(n-1),Rth(n-1),Rth(n),dt,Imax(j));
        Imod1(n)=ThermCurrent(Tmod1(n),Tmod1(n-1),Rth(n),c1,Imax(j),dt);
        V(n)=I(n)*Rth(n);
%         if flag==1;
%           if T(n)>Ttau
%             flag=0;
%             ttau(j)=t(n);
%           end
%         end 
    end
   
%     legend('with control', 'no control');
%     hold on
%     figure (2)
%     plot(t,I);
end

 figure (2)
    plot(t,T);
    hold on 
    plot (t,T_noCon);
     hold on
    %plot(t,T_NoCon1);
    %hold on
    plot(t,Tmod1);
    title('T(t)');
    xlabel('t[sec]');
    ylabel('T[K]');
    legend('2nd order control', 'No control','1st Order control');
    
    figure (3)
    plot(t,I);
    hold on 
    plot(t,Imod1);
    legend( 'mod2' ,'mod1');
%     xlim ([0 20]);

% ttau(j+1)=15;
% Ttaus=ones(j+1,1)*Ttau;
% plot(ttau,Ttaus,'.');


% r1=0.9*Rt;
% r2=0.3*Rt;  gives a good second order response , bad control
% c1=0.05*Ct;
% c2=0.95*Ct;