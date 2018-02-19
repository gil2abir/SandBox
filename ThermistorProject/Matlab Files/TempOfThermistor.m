function T = TempOfThermistor(I,T1,Rth,Ta,R,c,dt);
 T=((R*c/dt)*T1+R*((I)^2)*Rth+Ta)/((R*c/dt)+1); % caculate T according to differential equation
end
