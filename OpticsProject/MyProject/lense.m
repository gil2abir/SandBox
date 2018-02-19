function [ z,y,teta_i,teta_t,t,L ] = lense( z,y,teta,R,n1,n2 )
%% Finding L (using guidance given in lectures):
p = [1 , 2*(y*sind(teta)+z*cosd(teta)) , z^2+y^2-R^2];

L_temp = (roots(p));
L = min(abs(L_temp));

%% Finding interface and transfer angles: teta_i and teta_t
teta_i = acosd((1/abs(R))*abs((L+y*sind(teta)+z*cosd(teta))));
teta_t = asind((n1*sind(teta_i))/n2);

%% Finding fernel constants:
ts = (2*n1*cosd(teta_i))/(n1*cosd(teta_i)+n2*cosd(teta_t));
tp = (2*n1*cosd(teta_i))/(n1*cosd(teta_t)+n2*cosd(teta_i));
t = 0.5*((tp+ts));

%% Finding new y and z using snel law
vect = [z  y]+[cosd(teta) sind(teta)]*L;
z = vect(1);
y = vect(2);

end

