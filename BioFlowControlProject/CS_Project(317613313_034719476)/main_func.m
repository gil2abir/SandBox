function [c_Pao] = main_func( HR, V0 ,Emax, Ra, Rp, Rv, Ca, Cv,Vlv2,Va2,Vv2 )
% system parameters
% time scale parameters
dt=0.5e-3; %sec
N=floor(60/(HR*dt)); %******number of points per heart cycle,  rounds the elements  to the nearest integers.
Tcycles=50; % total heart cycles

% heart parameters
ts=round(N/3);
En(1:ts)=0.5*(1+sin(2*pi*(1:ts)/ts-pi/2));
En(ts+1:N)=0; %normalized LV 
Ed=10/120; 
E=max(Ed,Emax*En);

% initialization of variables
Plv(1:N)=0; % left ventricular pressure
Vlv(1:N)=Vlv2(1); % left ventricular volume
Qlv(1:N)=0; % left ventricular outflow
Pa(1:N)=70; % pressure on arterial capacitor
Va(1:N)=Va2(1); % volume on arterial capacitor
Qp(1:N)=0; % flow in peripheral resistance
Pv(1:N)=9; % venous filling pressure
Qv(1:N)=0; % ventricular filling inflow
Pao(1:N)=70; % aortic pressure
Vv(1:N)=Vv2(1); %venous vol

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


%% Main Program
for cycle=1:Tcycles
% main loop for each heat cycle
    for i=2:N
    %calculating all variables for each cycle at N points
        Vlv(i)=Vlv(i-1)+(Qv(i-1)-Qlv(i-1))*dt;
        Va(i)=Va(i-1)+(Qlv(i-1)-Qp(i-1))*dt;
        Vv(i)=Vv(i-1)+(Qp(i-1)-Qv(i-1))*dt;
        
        Plv(i)=E(i)*(Vlv(i)-V0);
        Pa(i)=Va(i)/Ca;
        Pv(i)=Vv(i)/Cv;
        
        Qlv(i)=max((Plv(i)-Pa(i))/Ra,0); % Looking for maximum value because there is diode so the current  have to go in one direction
        Qp(i)=(Pa(i)-Pv(i))/Rp; %Not looking for maximum value because there is NO diode and the current DOES NOT have to go in one direction
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


end;

end
