clear all;

% set global parsmeters

dt=0.0001; % time step , sec
t=0:dt:30;
dc=5e-3; %W/dC low coef
R=1/dc ; % dC/W 
tau=20; % sec
c=tau/R; %J/dC
beta=3800 ;
R0=250 ; %ohm
Imax=20e-3 ; % A , calculated by V/R where V=5v R=R0
lt = length(t);
T0=298; % initial temp K
T=ones(lt,1)*T0;
T1=ones(lt,1)*T0;
Rt=ones(lt,1)*R0; %thermistor 
V=zeros(lt,1);
I=zeros(lt,1);
Ta=310; % ambient temp

for n=2:lt
 Rt(n)=R0*exp(-beta*(1/T(n-1)-1/298)); % caculate resistence of ptc thermistor with previous T 
 T(n)=((R*c/dt)*T(n-1)+R*((I(n-1))^2)*Rt(n)+Ta)/((R*c/dt)+1); % caculate T according to differential equation
 dTdt=(T(n)-T(n-1))/dt; 
 I(n)=sqrt((c*dTdt)/Rt(n))*0.95; 
 if I(n)>Imax
     I(n)=Imax;
     %T1(t)=T(t); % I just wanted to check if and when we reach the max current
 end
 V(n)=I(n)*Rt(n);
end

subplot(2,2,1);
plot(t,T);
title('T(t)'); 
% hold on
% plot(t,T1,'o');
subplot(2,2,2);
plot(t,Rt);
title('Rt(t)');
subplot(2,2,3);
plot(t,V);
title('V(t)');
subplot(2,2,4);
plot(t,I);
title('I(t)');
xlabel('t');
ylabel('I');

 