function cvs_basic_template
%% system parameters

clear all 
close all
% time scale parameters
HR=80;                  % BPM
tmax=0.350;
dt=0.5e-3;              %sec
NN=floor(60/(40*dt));   % largest possible vector size for lowest HR - 40
N=floor(60/(HR*dt));    %number of points per heart cycle for HR=80

% heart model parameters 
Emax=2.0;
Vo=15;
%vascular parameters
Ra=0.1;                 % arterial resistance - series
Rp=1.0;                 % peripheral resistance
Rv=0.01;                % venous filling resistance
Ca=2.0;                 % arterial compliance
Ed=0.0666;              % heart diastolic elasticity 
% initialization  of variables
Plv(1:NN)=0;          % left ventricular pressure
Vlv(1:NN)=120;        % left ventricular volume
Qlv(1:NN)=0;          % left ventricular outflow
Pa(1:NN)=70;          % pressure on arterial capacitor
Va(1:NN)=270;         % volume on arterial capacitor
Qp(1:NN)=0;           % flow in peripheral resistance
Pv(1:NN)=9;           % venous filling pressure
Qv(1:NN)=0;           % ventricular filling inflow

Tcycles=20;             % total heart cycles
%% Main Program

for cycle=1:Tcycles
    E=EN(Emax,Ed,tmax,dt,N); %calculates E for the whole heart cycle

    % main loop for each time step
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
       
        
        
    end;
    % cycling variables
    Plv(1)=Plv(N);
    Vlv(1)=Vlv(N);
    Qlv(1)=Qlv(N);
    Pa(1)=Pa(N);
    Va(1)=Va(N);
    Qp(1)=Qp(N);
    Qv(1)=Qv(N);
end;


%% function for calculating Enormalized 

function E=EN(Emax,Ed,tmax,dt,N)
endsys=floor(2*tmax/dt);
En(1:endsys)=0.5*(1+sin(2*pi*(1:endsys)/endsys-pi/2));  %normalized LV elasticity
En(endsys+1:N)=0;
E=max(Ed,Emax*En);


