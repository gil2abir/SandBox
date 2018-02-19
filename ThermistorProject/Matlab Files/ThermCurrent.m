function I = ThermCurrent(T,T1,Rth,c,Imax,dt)
dTdt=(T-T1)/dt;  
I=sqrt((c*dTdt)/Rth)*0.97;
    if dTdt<=0 
      I=0;
    end
   
   if I>Imax
    I=0.985*Imax;  
    end
end