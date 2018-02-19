function [y_output,teta_output,I_percenteage,accumulated_phase] = Transfer_Simulator(lamda,z_input,z_output,y_input,teta_input)
%% Let us have the follow Achromatic lense paramters (in [mm])
R1 = 33.3; % Radius of curvature of left side of the first lense
R2 = -22.3; % Radius of curvature of right side of first lense (which will be radius of the left side of second lense)
R3 = -291.1; % Radius of curvature of right side of second lense
tc1 = 9; % Central thickness - first lens
tc = 11.5; % Total central thickness of Achromatic Doublet
Dia = 25.4; % Total diameter of Achromatic Doublet
te = 8.706; % Edge thickness
tc2 = 2.5; % Central thickness of second lens
n0 = 1; % Refractive index surrounding the lense
%according to equations:
n1 = sqrt(1+1.5851495/(1-0.00926681282*(lamda)^(-2))+0.143559385/(1-0.0424489805*(lamda)^(-2))+1.08521269/(1-105.613573*(lamda)^(-2))); % Refractive index lense no.1
n2 = sqrt(1+1.62153902/(1-0.0122241457*(lamda)^(-2))+0.256287842/(1-0.0595736775*(lamda)^(-2))+1.64447552/(1-147.468793*(lamda)^(-2))); % Refractive index lense no.2

%% Calculating the rays. proccess  input data first
z0 = -(abs(z_input)+R1);
y0 = y_input;
teta_initial = teta_input;

%get data of transfer in lense
[z1_temp , y1 , teta_i1 , teta_t1 , t1 , L1] = lense(z0 , y0 , teta_initial , R1 , n0 , n1);
z1 = R1-abs(z1_temp)+abs(R2)-tc1;
teta_temp1 = asind(y1/R1);
teta_first_transfer = teta_t1-teta_temp1;
z1_plot = abs(z0)-abs(z1_temp);
    
if teta_initial>0
    teta_first_transfer = teta_initial-(teta_i1-teta_t1);
end
 %keep tubular symmetry by adjusting teta
if y1<0
    teta_first_transfer = teta_i1-abs(teta_initial)-teta_t1; %%% dont change!!!!
end

%daw ray from image to first part

plot([0 z1_plot],[y0 y1],'red:');

%calculate second transfer
[z2_temp , y2 , teta_i2 , teta_t2 , t2 , L2] = lense(z1 , y1 , teta_first_transfer , R2 , n1 , n2);
z2 = abs(R3)-tc2+(abs(z2_temp)-abs(R2)); 
teta_transfer = -(teta_t2-teta_i2+abs(teta_first_transfer));
z2_plot = z1_plot+abs(z2_temp)-z1;

if teta_first_transfer>0
    teta_transfer = teta_first_transfer+(teta_i2-teta_t2);
end

if y2<0
    teta_transfer = abs(teta_first_transfer)-(teta_i2-teta_t2);
end

%draw ray in first lense
plot([z1_plot z2_plot],[y1 y2],'red:');

%calculate third transfer
[z3_temp , y3 , teta_i3 , teta_t3, t3 , L3] = lense(z2 , y2 , teta_transfer , R3 , n2 , n0);
teta_second_transfer = -(teta_t3-teta_i3+abs(teta_transfer));
z3_plot = z2_plot+abs(z3_temp)-z2;

if teta_transfer>0
    teta_second_transfer = teta_transfer+(teta_i3-teta_t3);
end

if y3<0
    teta_second_transfer = abs(teta_transfer)-(teta_i3-teta_t3);
end

%draw ray in second lense
plot([z2_plot z3_plot],[y2 y3],'red:');

L4 = (z_output-(z3_temp-abs(R3)))/cosd(teta_second_transfer);

y_output =  y3+L4*sind(teta_second_transfer);
    
teta_output = teta_second_transfer;

%calculate relative intensity of the Achromatic Lense
I_percenteage = t1*t2*t3;

%Calculate accumlulated phase throw the thick lense
accumulated_phase = (2*pi*(L1*n0+L2*n1+L3*n2+L4*n0))/(lamda/1000);

z_output_array = z3_plot+z_output-abs(z3_temp)+abs(R3);

%draw ray after lense
plot([z3_plot z_output_array],[y3 y_output],'red:');
end

