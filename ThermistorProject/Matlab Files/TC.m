clear
close all;

dt=1e-4;
N=10e4;
ts=(1:N)*dt;

beta=4000;
R25=10e3;

qmax=0; %W

tau=5; %sec
dc=0.03; %W/dC low coef
R=1/dc; % dC/W
C=tau/R; %J/dC

q=0;
T(1)=25;
Tm=37;
dTdt=0;

for t=2:N
    T(t)=((R*C/dt)*T(t-1)+R*q+Tm)/((R*C/dt)+1);
    dTdt=(T(t)-T(t-1))/dt;
     q=C*dTdt/1.01;
     if q<0 q=0; end;
     if q>qmax q=qmax; end;
     
end;
figure
plot(ts,T);
hold on

qmax=1.5; %W

tau=5; %sec
dc=0.03; %W/dC low coef
R=1/dc; % dC/W
C=tau/R; %J/dC

q=0;
T(1)=25;
Tm=37;
dTdt=0;

for t=2:N
    T(t)=((R*C/dt)*T(t-1)+R*q+Tm)/((R*C/dt)+1);
    dTdt=(T(t)-T(t-1))/dt;
     q=C*dTdt/1.01;
     if q<0 q=0; end;
     if q>qmax q=qmax; end;
     
end;

plot(ts,T);


