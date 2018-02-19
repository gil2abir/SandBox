function [P,Q,V] = seg_eff(P ,Q, V ,R, L, C, dt)

V(2,2) = V(1,2) + (Q(1,2)-Q(1,3))*dt; 
P(2,2) = V(2,2)/C;
Q(2,2)= (P(2,1)-P(2,2) + (L/dt)*(Q(1,2)))/(R + L/dt);
end

