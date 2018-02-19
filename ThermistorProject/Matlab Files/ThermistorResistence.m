function Rth = ThermistorResistence(T,R25,beta)
Rth=R25*exp(-beta*(1/T-1/298)); % caculate resistence of ptc thermistor with previous T (T(n-1))
end



