function T = TempOfTherm2 (a,b,c,d,dt,I1,I2,Rth1,Rth2,T1,T2,Ta)
qn=(I1^2)*Rth1;
qn_1=(I2^2)*Rth2;
T=((2*a+b*dt)*T1-a*T2+(c*dt+(dt^2)*d)*qn-c*dt*qn_1+Ta*(dt^2))/(a+b*dt+dt^2);
end