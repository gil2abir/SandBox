clear all;

tau=15;
dc=8.5e-3;
syms r1 r2 c1 c2;

res=solve( r1+r2==1/dc,...
           c1+c2==tau*dc,...
           r1*c1==0.08531,...
           r2*c2==3.462,'PrincipalValue',true);
       