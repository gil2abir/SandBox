
%Termistor gets parameters for analog circuit model for a termistor, and
%plots the step response

%simulation parameters
time=10;
dt=0.001;

%set model parameters and initialize vectors
q=16; %v^2/R
C=3;
R=600;
T=zeros(time/dt,1);
Tb=37+273; %Kelvin
T(1)=25+273; %Kelvin
for t=2:(time/dt)
    T(t) = T(t-1)+(1/C)*q+(Tb-T(t))/(R*C);
end

TimeVec=0:1:time/dt;
plot(TimeVec,T)



