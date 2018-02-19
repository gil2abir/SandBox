
function I= current2(a,b,c,d,T,T1,T2,I1,Rth1,Rth,dt,Imax)
%q(n)=((a/dt)*(T[n]-2*T[n-1]+t[n-2])+b*(T[n]-T[n-1])+c*q[n-1])/(c+dt*d);
q=((a/dt)*(T-2*T1+T2)+b*(T-T1)+c*(I1^2)*Rth1)/(c+dt*d);
 I=sqrt(q/Rth)*0.98;
   if q<0
      I=0;
   end
   if I>Imax
   I=Imax;  
   end
end
 
 
 
 

