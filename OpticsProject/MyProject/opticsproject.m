%% lets have a clean sheett
clc; close all; clear all;

%% Let us have the follow Achromatic lense paramters (in [mm])
R1 = 33.3; % Radius of curvature of left side of the first lense
R2 = -22.3; % Radius of curvature of right side of first lense (which will be radius of the left side of second lense)
R3 = -291.1; % Radius of curvature of right side of second lense
tc1 = 9; % Central thickness - first lens
tc = 11.5; % Total central thickness of Achromatic Doublet
Dia = 25.4; % Total diameter of Achromatic Doublet
te = 8.706; % Edge thickness
tc2 = 2.5; % Central thickness of second lens
lamda = 0.565; % Chosen Wavelength in um 
n0 = 1; % Refractive index surrounding the lense
%according to equations:
n1 = sqrt(1+1.5851495/(1-0.00926681282*(lamda)^(-2))+0.143559385/(1-0.0424489805*(lamda)^(-2))+1.08521269/(1-105.613573*(lamda)^(-2))); % Refractive index lense no.1
n2 = sqrt(1+1.62153902/(1-0.0122241457*(lamda)^(-2))+0.256287842/(1-0.0595736775*(lamda)^(-2))+1.64447552/(1-147.468793*(lamda)^(-2))); % Refractive index lense no.2

%% Ray transfer matrix of Achromatic Doublet according to prior calculations

Mt=[0.865706786309425,6.84822319516064;-0.0199663377803759,0.997180657633733];

%% Calculating focal points
A = Mt(1,1);
B = Mt(1,2);
C = Mt(2,1);
D = Mt(2,2);
up = (1-D)/C; % define the right principal plane
vp = (1-A)/C; % define the left principal plane
f = -1/C; % calculate effective focal length from Mt
fb = 43; % Backward focal length
ff = 47; % Forward focal length
L = ff+85;

%% First lets build our optic world

%lets draw the Achromatic doublet lense (2 thin lenses)
%using pitagoras, lets have the arch of the circle of R1 (imagine multipile edges of pitagoras triangles)
z1 = linspace(R1,sqrt(R1^2-(Dia/2)^2),300);
y1 = sqrt(R1^2-(z1).^2);
plot(-z1+R1+L,y1,'g');
hold on;
plot(-z1+R1+L,-y1,'g');

%using pitagoras, lets have the arch of the circle of R2 (imagine multipile edges of pitagoras triangles)
z2 = linspace(abs(R2),sqrt(R2^2-(Dia/2)^2),300);
y2 = sqrt(R2^2-(z2).^2);
plot(z2-abs(R2)+tc1+L,y2,'g');
plot(z2-abs(R2)+tc1+L,-y2,'g');

%using pitagoras, lets have the arch of the circle of R3 (imagine multipile edges of pitagoras triangles)
z3 = linspace(abs(R3),sqrt(R3^2-(Dia/2)^2),300);
y3 = sqrt(R3^2-z3.^2);
plot(z3-abs(R3)+tc+L,y3,'g');
plot(z3-abs(R3)+tc+L,-y3,'g');

%lets put some lids on the lenses so nothing important escapes
%lids will be lines between edges of 2 lenses
plot([L+R1-sqrt(R1^2-(Dia/2)^2),L+tc-(abs(R3)-sqrt(abs(R3)^2-(Dia/2)^2))],[Dia/2,Dia/2],'g');
plot([L+R1-sqrt(R1^2-(Dia/2)^2),L+tc-(abs(R3)-sqrt(abs(R3)^2-(Dia/2)^2))],[-Dia/2,-Dia/2],'g');


%%lets simulate 5 shiny rays of different random angles and trace them. all
%%rays starts at single point.
%ray starts at
z_input = L;
%and ends at
z_output = fb+85;
%with height of
y_input = 6;

%create symmetric tubular behavor around z axis
if y_input>Dia/2
    gamma = y_input-Dia/2;
    beta = y_input+Dia/2;
else
    beta = Dia/2-y_input;
    gamma = y_input+Dia/2;
end
%lets define our angles limits according to the angles forms between the
%distance of the lense and the rays starting point
teta_in_lower = atand(gamma/(z_input+R1-sqrt(R1^2-(Dia/2)^2))); % Minimum starting angle allowed
teta_in_higher = atand(beta/(z_input+R1-sqrt(R1^2-(Dia/2)^2))); % Maximum angle allowed

if y_input>Dia/2
    teta_in_lower = -teta_in_lower;
    teta_in_higher =  -teta_in_higher;
else
   teta_in_lower = -teta_in_lower;
   teta_in_higher =  teta_in_higher;
end 


teta_in = (tc2)*rand(1,1) + 0;

%lets create those 5 rays, each ray contains data of height above z, angles, phase
%occumulated until output 
[yf(1),tetacyrc(1),I_rel(1),phase_until_output(1)] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_in);

teta_in = rand(1,1);
[yf(2),tetacyrc(2),I_rel(2),phase_until_output(2)] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_in);

teta_in = rand(1,1);
[yf(3),tetacyrc(3),I_rel(3),phase_until_output(3)] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_in);

teta_in = 3*rand(1,1) -(3*2);
[yf(4),tetacyrc(4),I_rel(4),phase_until_output(4)] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_in);

teta_in = 3*rand(1,1) -(3*2);
[yf(5),tetacyrc(5),I_rel(5),phase_until_output(5)] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_in);

%define the z axis and output plain
plot([z_output+L+tc,z_output+L+tc],[-2*Dia,2*Dia],'black');
plot([0,z_output+L+tc],[0,0],'black');

%plot the mess from above
title('5 Ray Tracing Simulation');
xlabel('z axis[mm]');
ylabel('y axis[mm]');

figure;

%% lets repeat the above, now with endless number of parallel rays. hoping my laptop wont explode
L = ff+10;
z1 = linspace(R1,sqrt(R1^2-(Dia/2)^2),300);
y1 = sqrt(R1^2-(z1).^2);
plot(-z1+R1+L,y1,'g');
hold on;
plot(-z1+R1+L,-y1,'g');

z2 = linspace(abs(R2),sqrt(R2^2-(Dia/2)^2),300);
y2 = sqrt(R2^2-(z2).^2);
plot(z2-abs(R2)+tc1+L,y2,'g');
plot(z2-abs(R2)+tc1+L,-y2,'g');

z3 = linspace(abs(R3),sqrt(R3^2-(Dia/2)^2),300);
y3 = sqrt(R3^2-z3.^2);
plot(z3-abs(R3)+tc+L,y3,'g');
plot(z3-abs(R3)+tc+L,-y3,'g');

plot([L+R1-sqrt(R1^2-(Dia/2)^2),L+tc-(abs(R3)-sqrt(abs(R3)^2-(Dia/2)^2))],[Dia/2,Dia/2],'b');

plot([L+R1-sqrt(R1^2-(Dia/2)^2),L+tc-(abs(R3)-sqrt(abs(R3)^2-(Dia/2)^2))],[-Dia/2,-Dia/2],'b');
%% Now we will trace the Rays starting at different heights 
z_input = L;
z_output = fb;
y_input_max = Dia/2;
y_input_min = -(Dia/2);
teta_in = 0;
%we were told we need 10,000 rays. wow! talk about wise power
%consumption...
for m = 1 : 10000
    y_input = (y_input_max-y_input_min)*rand(1,1) + y_input_min;
    [yf_2(m),tetacyrc_2(m),I_rel_2(m),phase_until_output_2(m)] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_in);
end
hold on;

plot([z_output+L+tc,z_output+L+tc],[-Dia/2,Dia/2],'black');
plot([0,z_output+L+tc],[0,0],'black')

title('10,000 Parallel Rays Tracing Simulation - a Straight Beam of light');
xlabel('z axis[mm]');
ylabel('y axis[mm]');

%% Calculating the intensity distribution - PSF
epsilon = 0.001; % 1 micron
lower_part = -max(abs(yf_2));
higher_part = max(yf_2);

right_inter = lower_part+epsilon;
left_iter = lower_part;
% lets split the focal plain to 0.001 steps epsilonels, and count how many rays
% hit each epsilonel. 
k = 1;
while left_iter <= higher_part
    total_ray(k) = 0;
    for j = 1:length(yf_2)
        %hwo many rays in this epsilonel?
        if yf_2(j) >= left_iter && yf_2(j) <= right_inter
            %complex addition: magnitude + phase
            total_ray(k) = total_ray(k) + I_rel_2(j)*(exp(1i*phase_until_output_2(j)));
        end
    end
    %continue this for the all plain
    k = k+1;
    right_inter = right_inter + epsilon;
    left_iter = left_iter + epsilon;
end

%square magnitude of each epsilonel
for m = 1 : length(total_ray)
    PSF(m) = (abs(total_ray(m)))^2;
end

y = lower_part:epsilon:higher_part;

%for m = 1 : length(PSF)
%    if y(m)<-0.04 || y(m)>0.04
%        PSF(m) = 0;
%    end
%end

PSF_normalized = PSF/max(PSF);

figure;

plot(y,PSF_normalized);

title('Point Spread Function (PSF) of an Achromatic Doublet');
xlabel('y axis[mm]');
ylabel('Relative Intensity[(L^?2)*J]');

%% Calculating MTF
MTF = abs(fft(PSF));
length_MTF = length(MTF);
MTF_new = MTF(1:(length_MTF/2));
MTF_normalized = MTF_new/max(MTF_new);

N = length(PSF);

q=0:(N-1)/2;

Fs = 1/epsilon;
   
T = N/Fs;
    
freq = q/T;

figure;

plot(freq(1:length(MTF_normalized)),MTF_normalized);


title('Modulation Transfer Function (MTF) of an Achromatic Doublet');
xlabel('Spatial Frequency[1/mm]');
ylabel('MTF[#]');

figure;
yy2 = smooth(freq(1:length(MTF_normalized)),MTF_normalized,0.1,'rloess');
plot(freq(1:length(MTF_normalized)),MTF_normalized,'b.',freq(1:length(MTF_normalized)),yy2,'r-')
set(gca,'YLim',[-1.5 3.5])
legend('Original Data','Smoothed Data Using ''rloess''',...
       'Location','NW')
   hold on;
   XY1=[0,1];
   XY2=[1000,0];
   
   plot(XY1,XY2);

title('Modulation Transfer Function (MTF) of an Achromatic Doublet');
xlabel('Spatial Frequency[1/mm]');
ylabel('MTF[#]');
    




 


