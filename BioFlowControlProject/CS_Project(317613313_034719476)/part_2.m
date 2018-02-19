clc
clear all
close all
% system parameters
% time scale parameters
HR=80; % BPM
HR_2=[0.5*HR:1:2.5*HR];
dt=0.5e-3; %sec
N=floor(60/(HR*dt)); %number of points per heart cycle,  rounds the elements  to the nearest integers.
Tcycles=100; % total heart cycles

% heart parameters
V0=15; % V0 for PLV calculation
Emax=2.0; % contractility
Emax_2=[0.5*Emax:0.2:2.5*Emax];

%vascular parameters
Ra=0.1; % arterial resistance - series
Rp=1.0; % peripheral resistance
Rp_2=[0.5*Rp:0.15:2.5*Rp];
Rv=0.01; % venous filling resistance
Ca=2.0; % arterial compliance
Cv=300; %venous compliance
Cv_2=[0.5*Cv:25:2.5*Cv];

% initialization of variables
vec=[0.5:0.1:2.5];
Vlv(1:N)=120; % left ventricular volume
Vlv_vec=Vlv*vec(1);
for i=2:length(vec)
    Vlv_vec=[Vlv_vec;vec(i)*Vlv];
end;
Va(1:N)=270; % volume on arterial capacitor
Va_vec=Va*vec(1);
for j=2:length(vec)
    Va_vec=[Va_vec;vec(j)*Va];
end;
Vv(1:N)=2700; %venous vol
Vv_vec=Vv*vec(1);
for k=2:length(vec)
    Vv_vec=[Vv_vec;vec(k)*Vv];
end;

%% Main Program
Pao_100=mean(main_func( HR, V0 ,Emax, Ra, Rp, Rv, Ca, Cv,Vlv,Va,Vv));

%Cv
Pao_Cv_mat=main_func( HR, V0 ,Emax, Ra, Rp, Rv, Ca, Cv_2(1) ,Vlv,Va,Vv);
for i=2:length(Cv_2)
    
    Pao_Cv_mat=[Pao_Cv_mat;main_func( HR, V0 ,Emax, Ra, Rp, Rv, Ca, Cv_2(i) ,Vlv,Va,Vv)];
    
end;
Pao_Cv_mean=mean(Pao_Cv_mat,2);
Pao_pCv=Pao_Cv_mean/Pao_100;

%Rp
Pao_Rp_mat=main_func( HR, V0 ,Emax, Ra, Rp_2(1), Rv, Ca, Cv,Vlv,Va,Vv);
for j=2:length(Rp_2)
    
    Pao_Rp_mat=[Pao_Rp_mat;main_func( HR, V0 ,Emax, Ra, Rp_2(j), Rv, Ca, Cv,Vlv,Va,Vv )];
    
end;
Pao_Rp_mean=mean(Pao_Rp_mat,2);
Pao_pRp=Pao_Rp_mean/Pao_100;

%Emax
Pao_Emax_mat=main_func( HR, V0 ,Emax_2(1), Ra, Rp, Rv, Ca, Cv,Vlv,Va,Vv);
for k=2:length(Emax_2)
    
    Pao_Emax_mat=[Pao_Emax_mat;main_func( HR, V0 ,Emax_2(k), Ra, Rp, Rv, Ca, Cv,Vlv,Va,Vv)];
    
end;
Pao_Emax_mean=mean(Pao_Emax_mat,2);
Pao_pEmax=Pao_Emax_mean/Pao_100;

%HR
Pao_HR_vec_mean=mean(main_func( HR_2(1), V0 ,Emax, Ra, Rp, Rv, Ca, Cv,Vlv,Va,Vv));
for h=2:length(HR_2)
    
    Pao_HR_vec_mean=[Pao_HR_vec_mean;mean(main_func( HR_2(h), V0 ,Emax, Ra, Rp, Rv, Ca, Cv,Vlv,Va,Vv))];
    
end;

Pao_pHR=Pao_HR_vec_mean/Pao_100;

%BV

Pao_BV_vec_mean=mean( main_func( HR, V0 ,Emax, Ra, Rp, Rv, Ca, Cv,Vlv_vec(1),Va_vec(1),Vv_vec(1)));
for g=2:length(vec)
    
    Pao_BV_vec_mean=[Pao_BV_vec_mean;mean(main_func( HR, V0 ,Emax, Ra, Rp, Rv, Ca, Cv,Vlv_vec(g),Va_vec(g),Vv_vec(g)))];
    
end;

Pao_pBV=Pao_BV_vec_mean/Pao_100;


%plotting commands

L_Cv=(200/(length(Pao_pCv)-1));
x_Cv=(50:L_Cv:250);
plot(x_Cv,Pao_pCv,'r','linewidth',2);

hold on

L_Rp=(200/(length(Pao_pRp)-1));
x_Rp=(50:L_Rp:250);
plot(x_Rp,Pao_pRp,'Color', [1 0.85 0],'linewidth',2);


hold on

L_Emax=(200/(length(Pao_pEmax)-1));
x_E=(50:L_Emax:250);
plot(x_E,Pao_pEmax,'Color',[0.5 0.75 0],'linewidth',2);

hold on


L_HR=(200/(length(Pao_pHR)-1));
x_HR=(50:L_HR:250);
plot(x_HR,Pao_pHR,'b','Color',[0 0.3 1],'linewidth',2);


hold on

L_BV=(200/(length(Pao_pBV)-1));
x_BV=(50:L_BV:250);
plot(x_BV,Pao_pBV,'Color', [0.6 0 0.7],'linewidth',2);

xlabel('% of Change')
ylabel('Normalized Mean Artrial Pressure')
title('Sensativity of Aotric Pressure to 5 Different Variables')
legend({'Venous Compliance' 'Peripheral Resistance' 'Contractility' 'Heart Rate' 'Total Blood Volume'});






