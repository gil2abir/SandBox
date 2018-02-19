function cvs_basic_template
%% system parameters
close all
clear all 

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
Cv=300.0;               % venous compliance
Ed=0.0666;              % heart diastolic elasticity 
% initialization  of variables
Plv(1:NN)=0;          % left ventricular pressure
Pa0(1:NN)=0; 
Vlv(1:NN)=120;        % left ventricular volume
Qlv(1:NN)=0;          % left ventricular outflow
Pa(1:NN)=70;          % pressure on arterial capacitor
Va(1:NN)=270;         % volume on arterial capacitor
Vv(1:NN)=2700;        % volume on venous capacitor
Qp(1:NN)=0;           % flow in peripheral resistance
Pv(1:NN)=9;           % venous filling pressure
Qv(1:NN)=0;           % ventricular filling inflow

Tcycles=20; % total heart cycles
Pcycles=10; % number of cycles to print (from the end)

 
 t=dt:dt:(N*dt*Pcycles);

%% Main Program

for cycle=1:Tcycles
    E=EN(Emax,Ed,tmax,dt,N); %calculates E for the whole heart cycle

    % main loop for each time step
    for i=2:N
      
        Vlv(i)=Vlv(i-1)+(Qv(i-1)-Qlv(i-1))*dt;
        Va(i)=Va(i-1)+(Qlv(i-1)-Qp(i-1))*dt;
        Vv(i)=Vv(i-1)+(Qp(i-1)-Qv(i-1))*dt;
        Plv(i)=E(i)*(Vlv(i)-Vo);
        Pa(i)=1/Ca*Va(i);
        Pv(i)=1/Cv*Vv(i);
        if Plv(i)>Pa
            Pa0(i)=Plv(i);
        else 
            Pa0(i)=Pa(i);
        end
        Qv(i)=max([0 (Pv(i)-Plv(i))/Rv]);
        Qlv(i)=max([0 (Pa0(i)-Pa(i))/Ra]);
        Qp(i)=(Pa(i)-Pv(i))/Rp;
    end;

    % cycling variables
    Plv(1)=Plv(N);
    Vlv(1)=Vlv(N);
    Qlv(1)=Qlv(N);
    Pa(1)=Pa(N);
    Pa0(1)=Pa0(N);
    Pv(1)=Pv(N);
    Va(1)=Va(N);
    Qp(1)=Qp(N);
    Qv(1)=Qv(N);
    Vv(1)=Vv(N);
    
    if cycle>(Tcycles-Pcycles)
     Vlv_m((cycle-(Tcycles-Pcycles)),:)=Vlv(1:N);
     Va_m((cycle-(Tcycles-Pcycles)),:)=Va(1:N);
     Vv_m((cycle-(Tcycles-Pcycles)),:)=Vv(1:N);
     Plv_m((cycle-(Tcycles-Pcycles)),:)=Plv(1:N);
     Pa_m((cycle-(Tcycles-Pcycles)),:)=Pa(1:N);
     Pa0_m((cycle-(Tcycles-Pcycles)),:)=Pa0(1:N);
     Pv_m((cycle-(Tcycles-Pcycles)),:)=Pv(1:N);
     Qv_m((cycle-(Tcycles-Pcycles)),:)=Qv(1:N);
     Qlv_m((cycle-(Tcycles-Pcycles)),:)=Qlv(1:N);
     Qp_m((cycle-(Tcycles-Pcycles)),:)=Qp(1:N);
     
    
    end
    
    
end;

Vlv_mt=Vlv_m';
Va_mt=Va_m';
Vv_mt=Vv_m';
Plv_mt=Plv_m';
Pa_mt=Pa_m';
Pa0_mt=Pa0_m';
Pv_mt=Pv_m';
Qv_mt=Qv_m';
Qlv_mt=Qlv_m';
Qp_mt=Qp_m';
%%
figure;
subplot(3,1,1)
%plot the volumes 
plot(t,Vlv_mt(:),'g');
hold on
plot(t,Va_mt(:),'b');
hold on
plot(t,Vv_mt(:),'r');
title('Volume as a function of time');
xlabel('Time [sec]');
ylabel('Volume [ml]');
ylim([0 3000]);
legend('Vlv','Va','Vv');
subplot(3,1,2)
%plot the Pressures 
plot(t,Plv_mt(:),'g');
hold on
plot(t,Pa_mt(:),'b');
hold on
plot(t,Pa0_mt(:),'r');
hold on
plot(t,Pv_mt(:),'k');
title('Pressure as a function of time');
xlabel('Time [sec]');
ylabel('Pressure [mmHg]');
ylim([0 140]);
legend('Plv','Pa','Pa0','Pv');
subplot(3,1,3)
%plot the volumetric flow rate
plot(t,Qlv_mt(:),'g');
hold on
plot(t,Qv_mt(:),'r');
hold on
plot(t,Qp_mt(:),'b');
title('volumetric flow rate as a function of time');
xlabel('Time [sec]');
ylabel('volumetric flow rate [mmHg]');
ylim([0 600]);
legend('Qlv','Qv','Qp');



