b = 4000;
T0 = 25+273;
R0 = 3.36*10^3;
Tout = 37+273;
delta = 16/0.002; %(V^2/D.C)
N = 20;
R(1) = R0;
for i=2:N
T(i) = Tout + delta/R(i-1);
R(i) = R0*exp(b*(1/T(i)-1/T0));
end
