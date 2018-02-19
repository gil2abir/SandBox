function [ c_Pao_mean ] = Pao_mean_PID( KP,KD,KI )
% system parameters
% time scale parameters
HR=80; % BPM
dt=0.5e-3; %sec
N=floor(60/(HR*dt)); %******number of points per heart cycle,  rounds the elements  to the nearest integers.
Tcycles=100; % total heart cycles

% heart parameters
V0=15; % V0 for PLV calculation
Emax=2.0; % contractility
ts=round(N/3);
En(1:ts)=0.5*(1+sin(2*pi*(1:ts)/ts-pi/2));
En(ts+1:N)=0; %normalized LV 
Ed=10/120; 
E=max(Ed,Emax*En); %******combine diastolic and systolic elasticity functions

%vascular parameters
Ra=0.1; % arterial resistance - series
Rp=1.0; % peripheral resistance
Rv=0.01; % venous filling resistance
Ca=2.0; % arterial compliance
Cv=300; %venous compliance

error(1:Tcycles)=0;
S_I=0;
S_D=0;


% initialization of variables
Plv(1:N)=0; % left ventricular pressure
Vlv(1:N)=120; % left ventricular volume
Qlv(1:N)=0; % left ventricular outflow
Pa(1:N)=70; % pressure on arterial capacitor
Va(1:N)=270; % volume on arterial capacitor
Qp(1:N)=0; % flow in peripheral resistance
Pv(1:N)=9; % venous filling pressure
Qv(1:N)=0; % ventricular filling inflow
Pao(1:N)=70; % aortic pressure
Vv(1:N)=2700; %venous vol

%continuous variables (c_var)
c_Plv=0;
c_Vlv=0;
c_Qlv=0;
c_Pa=0;
c_Qp=0;
c_Pv=0;
c_Qv=0;
c_Pao=0;
c_Vv=0;
c_Pao_mean=0;
PID(1:Tcycles)=0;
PID(1)=1;
Pao_ref=80;
 Cv_ref=0;
 Cva=300;


%% Main Program
for cycle=1:Tcycles
    if (cycle==60)
         Vlv(1)=Vlv(1)*0.8;
        Va(1)=Va(1)*0.8;
        Vv(1)=Vv(1)*0.8;
    end
% main loop for each heat cycle
    for i=2:N
    %calculating all variables for each cycle at N points
        Vlv(i)=Vlv(i-1)+(Qv(i-1)-Qlv(i-1))*dt;
        Va(i)=Va(i-1)+(Qlv(i-1)-Qp(i-1))*dt;
        Vv(i)=Vv(i-1)+(Qp(i-1)-Qv(i-1))*dt;
        
        Plv(i)=E(i)*(Vlv(i)-V0);
        Pa(i)=Va(i)/Ca;
        Pv(i)=Vv(i)/(Cv*PID(cycle));
        
        Qlv(i)=max((Plv(i)-Pa(i))/Ra,0);
        Qp(i)=(Pa(i)-Pv(i))/(Rp*PID(cycle));
        Qv(i)=max((Pv(i)-Plv(i))/Rv,0);
        
        Pao(i)=Pa(i)+Qlv(i)*Ra;
        
     
    end;

%saving variables from cycle to continuous variables (c_var)
c_Plv=[c_Plv Plv(1:N)];
c_Vlv=[c_Vlv Vlv(1:N)];
c_Qlv=[c_Qlv Qlv(1:N)];
c_Pa=[c_Pa Pa(1:N)];
c_Qp=[c_Qp Qp(1:N)];
c_Pv=[c_Pv Pv(1:N)];
c_Qv=[c_Qv Qv(1:N)];
c_Pao=[c_Pao Pao(1:N)];
c_Vv=[c_Vv Vv(1:N)];

Pao_mean=mean(Pao(1:N));
c_Pao_mean=[c_Pao_mean Pao_mean];
%cycling variables
 Vlv(1)=Vlv(N);
 Va(1)=Va(N);
 Vv(1)=Vv(N);      
 Plv(1)=Plv(N);
 Pa(1)=Pa(N);
 Pv(1)=Pv(N);    
 Qlv(1)=Qlv(N); 
 Qp(1)=Qp(N);
 Qv(1)=Qv(N);
        
 Pao(1)= Pao(N);

 error(cycle)=Pao_ref-Pao_mean;
 S_I=S_I+error(cycle); % Integral
 if (cycle~=1)
     S_D=error(cycle)-error(cycle-1);% Derivative
 else
     S_D=error(cycle);
 end
 PID(cycle+1)=1+KP*error(cycle)+KI*S_I+KD*S_D;
 HR=max(60,HR*PID(cycle+1));
 N=max(1,floor(60/(HR*dt))); %******number of points per heart cycle,  rounds the elements  to the nearest integers.
 Emax=Emax*PID(cycle+1);
 ts=round(N/3);
 En(1:ts)=0.5*(1+sin(2*pi*(1:ts)/ts-pi/2));
 En(ts+1:N)=0; %normalized LV
 E=max(Ed,Emax*En);
 

end;


end

