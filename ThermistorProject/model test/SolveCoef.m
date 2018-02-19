reset(symengine);
clear all
Tf=35.2;
Ti=22.5;
a=3.6;
b=0.08;
c=9;
d=3;

Tstep=Tf-Ti;
x1=(-2*Tstep)/a;
x2=2*b;
x3=(2*Tstep)/c;
x4=2*d;

syms r1 r2 c1 c2;

s=solve(x1==((((r2*c2+r1*c1+c1*r2)^2-4*r1*r2*c1*c2)^(1/2))*((-(r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))+(((r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))^2-4/(r1*r2*c1*c2))^(1/2))),...
        x2==((-(r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))+((((r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))^2-4/(r1*r2*c1*c2))^(1/2))),...
        x3==((((r2*c2+r1*c1+c1*r2)^2-4*r1*r2*c1*c2)^(1/2))*((-(r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))-(((r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))^2-4/(r1*r2*c1*c2))^(1/2))),...
        x4==((-(r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))-((((r2*c2+r1*c1+c1*r2)/(r1*r2*c1*c2))^2-4/(r1*r2*c1*c2))^(1/2))),'PrincipalValue',true  );
  


% s=solve(coef1==Tstep*2/((r1*c2+r1*c1-r1*r2)*((r1*c2+r1*c1-r1*r2)^2+4*r1*r2*c1*c2)^(1/2)+(r1*c2+r1*c1-r1*r2)^2+4*r1*r2*c1*c2),...
%          coef2==0.5*(((r1*c2+r1*c1-r1*r2)/(r1*r2*c1*c2))+(((r1*c2+r1*c1-r1*r2)/(r1*r2*c1*c2))^2+4/(r1*r2*c1*c2))^(1/2)),...
%          coef3==-Tstep*2/((r1*c2+r1*c1-r1*r2)*((r1*c2+r1*c1-r1*r2)^2+4*r1*r2*c1*c2)^(1/2)-(r1*c2+r1*c1-r1*r2)^2-4*r1*r2*c1*c2),...
%          coef4==0.5*(((r1*c2+r1*c1-r1*r2)/(r1*r2*c1*c2))-(((r1*c2+r1*c1-r1*r2)/(r1*r2*c1*c2))^2+4/(r1*r2*c1*c2))^(1/2)));
%   
% s=solve(coef1==-Tstep*2/((r1*c2+r1*c1+r1*r2)*((r1*c2+r1*c1+r1*r2)^2+4*r1*r2*c1*c2)^(1/2)+(r1*c2+r1*c1+r1*r2)^2+4*r1*r2*c1*c2),...
%          coef2==0.5*(((r1*c2+r1*c1+r1*r2)/(r1*r2*c1*c2))+(((r1*c2+r1*c1+r1*r2)/(r1*r2*c1*c2))^2+4/(r1*r2*c1*c2))^(1/2)),...
%          coef3==Tstep*2/((r1*c2+r1*c1+r1*r2)*((r1*c2+r1*c1+r1*r2)^2+4*r1*r2*c1*c2)^(1/2)-(r1*c2+r1*c1+r1*r2)^2-4*r1*r2*c1*c2),...
%          coef4==0.5*(((r1*c2+r1*c1+r1*r2)/(r1*r2*c1*c2))-(((r1*c2+r1*c1+r1*r2)/(r1*r2*c1*c2))^2+4/(r1*r2*c1*c2))^(1/2)));
