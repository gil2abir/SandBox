
%Collected model for a pressure transducer
%By: Gil Abir Cavalero & Meital Cohen-Adiv

%purpose: modeling a long thick tube with a thin tube connected to a pressure transducer
%         and compare different amount of N,M segments to indicate the performance of a
%         concatenated model of N tube segments, over a collected model of a tube:

%the model: Pin-|--/\/\/\--SSS--|-/\/\/\--SSS----...--/\/\/\--SSS-|-Pout
%               |               |                |                | 
%               |_______________|________________|..._____________|
%-------------------------------------------------------------------------

%define parameters:

clear all;
%%% set time intervals and vector
dt = 1*10^-4;%=msec
T = 12000; 
time = linspace (0,dt*T,T); % in sec 
%define parameters:

% %fluid viscosity of water
% mu=(0.8)*((10)^(-3)); %N*S/m^2 
% %fluid density of water
% dens=1*10^3; %kg/m^3
% % tube's parameters: %s for short & thing tube, _l for long & thick tube
% %inner radius
% ri_s=7*(10^(-4)); ri_l=1.2*(10^(-3)); %m
% %tube wall thickness
% h_s=3*(10^(-4)); h_l=6*(10^(-4)); %m
% %length of tube
% l_s=3.2*(10^(-2)); l_l=0.6; %m
% %Young's Modulus
% E_s=26*10^6; E_l=11*10^6; %N/m^2
% 
% %Components of analog electrical model:
% %Compliance:
% C_l=(3*pi*l_l*(ri_l^3))/(2*h_l*E_l);%m^5/N
% C_s=(3*pi*l_s*(ri_s^3))/(2*h_s*E_s); %m^5/N
% 
% C_t=1*(10^(-12)); %m^5/N, transducer's compliance
% C_eq = ((C_t)+(C_l)); %m^5/N
% %Resistance:
% R_l = (8*l_l*mu)/(pi*(ri_l^4)); R_s = (8*l_s*mu)/(pi*(ri_s^4)); R_eq = R_l + R_s; % N*sec/m^5;
% % R_l=R_l/10;
% % Inertia:
% L_l=(dens*l_l)/(pi*(ri_l)^2); L_s=(dens*l_s)/(pi*(ri_s)^2); L_eq = L_l + L_s; %kg/m^4
% 
% 


%stam params
R_s=4.7746e+09;
R_l=5.0908e+09;
L_s=1.1937e+08;
L_l=3.8977e+08;
C_s=6.0319e-14;
C_l=3.2327e-12;
C_t=1*(10^-12);
C_eq=C_l+C_t;

fracN1 = 10;

%lumped
P(T,4)=0;
Q(T,4)=0;
V(T,4)=0;
P(:,1)=1;
for t=2:T-1
%for short
    [P(t-1:t+1,1:3),Q(t-1:t+1,1:3),V(t-1:t+1,1:3)]=seg_eff(P(t-1:t+1,1:3) ,Q(t-1:t+1,1:3), V(t-1:t+1,1:3),R_s, L_s, C_s, dt);  
%for long
    [P(t-1:t+1,2:4),Q(t-1:t+1,2:4),V(t-1:t+1,2:4)]=seg_eff(P(t-1:t+1,2:4) ,Q(t-1:t+1,2:4), V(t-1:t+1,2:4),R_l, L_l, C_eq, dt);  
end
% end

% %% Plot step response of lumped model 
plot (time(1:end-1),P(1:end-1,3));
xlabel 'Time [Seconds]';
ylabel 'Amplitude';
title 'Step Response' ;
% legend (['Lumped Model']);
hold on;

% figure
% % 
% % for j=1:7
% % N1=j;
% % N2=N1*fracN1;


N1=25
N2=100

P=zeros(T,N1+N2+2);
V=zeros(T,N1+N2+2);
Q=zeros(T,N1+N2+2);
P(:,1)=1;

for t=2:T-1
    for n=2:N1+1 %short
         [P(t-1:t+1,n-1:n+1),Q(t-1:t+1,n-1:n+1),V(t-1:t+1,n-1:n+1)]=seg_eff(P(t-1:t+1,n-1:n+1) ,Q(t-1:t+1,n-1:n+1), V(t-1:t+1,n-1:n+1), R_s/N1, L_s/N1, C_s/N1, dt);  
    end
    for n=N1+2:N1+N2 %long
         [P(t-1:t+1,n-1:n+1),Q(t-1:t+1,n-1:n+1),V(t-1:t+1,n-1:n+1)]=seg_eff(P(t-1:t+1,n-1:n+1) ,Q(t-1:t+1,n-1:n+1), V(t-1:t+1,n-1:n+1), R_l/N2, L_l/N2, C_l/N2, dt);  
    end
    %%last seg 
    [P(t-1:t+1,N1+N2:N1+N2+2),Q(t-1:t+1,N1+N2:N1+N2+2),V(t-1:t+1,N1+N2:N1+N2+2)]=seg_eff(P(t-1:t+1,N1+N2:N1+N2+2) ,Q(t-1:t+1,N1+N2:N1+N2+2), V(t-1:t+1,N1+N2:N1+N2+2), R_l/N2, L_l/N2, C_l/N2+C_t, dt);
end
plot(time(1:end-1),P(1:end-1,N1+N2+1));
hold on 
xlabel 'Time [Seconds]';
ylabel 'Amplitude';
% legendInfo{j} = ['segmented Model  N = ' num2str(j) ', M= ' num2str(j*10) ];
% legend(legendInfo);
hold on 


legend ('Lumped Model','segmented Model  ');
% end 

