SigmaSpec = [0.39:0.001:0.7]; %let us have a visible spectrum vector
r1=33.3;
r2=-22.3;
r3=-291.1;

%lets calculate the refractive indexes, focals for each thin lense and effective focal length for the doublet
for i=1:311

n1(i)=(1+(1.5851495/(1-(0.00926681282*SigmaSpec(i)^-2)))+(0.143549385/(1-(0.0424389805*SigmaSpec(i)^-2)))+(1.08521269/(1-(105.613573*SigmaSpec(i)^-2))))^0.5;
f1(i)=(1/(n1(i)-1))*((r1)*(r2)/((r2)-(r1)));
n2(i)=(1+(1.62153902/(1-(0.0122241457*SigmaSpec(i)^-2)))+(0.256287842/(1-(0.0595736755*SigmaSpec(i)^-2)))+(1.64437552/(1-(147.468793*SigmaSpec(i)^-2))))^0.5;
f2(i)=(1/(n2(i)-1))*((r2)*(r3)/((r3)-(r2)));

Fefl(i)=(((1/f1(i))+(1/f2(i))))^-1;

end

%plot it
plot(SigmaSpec,Fefl)



