clc
clear all
close all


KP=0.0099999/2;
KD=0.0058;
KI=0.00;
Pao_mean=Pao_mean_PID(KP,KD,KI);
Pao_no_control=Pao_mean_PID(0,0,0);
%plotting commands
figure;

plot(Pao_mean,'g','linewidth',3); 
hold on
plot(Pao_no_control,'linewidth',3);
grid on ;
xlabel('Cycles performed')
ylabel('Mean Artrial Pressure (Pao)')
legend({'Artrial Controlled Pressure with PID' 'Atrial Pressure without PID' });





