%function [] = TubeTransducerModeling(N,M,Nloop)
%Collected model for a pressure transducer
%By: Gil Abir Cavalero & Meital Cohen-Adiv

%purpose: modeling a long thick tube with a thin tube connected to a pressure transducer
%         and compare different amount of N,M segments to indicate the performance of a
%         concatenated model of N tube segments, over a collected model of a tube:

%the model: Pin-|--/\/\/\--SSS--|-/\/\/\--SSS----...--/\/\/\--SSS-|-Pout
%               |               |                |                | 
%               |_______________|________________|..._____________|
%-------------------------------------------------------------------------

%define parameters:

%fluid vesocity of water
u=(0.8)*((10)^(-3)); %N*S/m^2 
%fluid density of water
d=1*10^3; %kg/m^3
%parameters for the tubes:
%_s for thin tube, _b for thick tube
%inner radius
ri_s=7*10^(-4); %m
ri_b=1.2*(10^(-3)); %m
%tube wall thickness
h_s=3*(10^(-4)); %m
h_b=6*(10^(-4)); %m
%length of tube
l_s=3.2*(10^(-2)); %m
l_b=0.6; %m
%elasticity coefficien
E_s=26*10^6; %N/m^2
E_b=11*10^6; %N/m^2

%segments for thick tube:
%Thick Tube compliance is Cb - For N segments - normal tube
Cb=(1.5*l_b*(ri_b^3))/(h_b*E_b);
%and resistance of
Rb = (8*l_b*u)/(pi*(ri_b^4));
%Fluid inertia is L
Lb=(d*l_b)/(pi*(ri_b)^2);


%final segment which represents thin tube with a sensor, will have a
%compliance of CN
%compliance for the transducer
Csensor=1*(10^(-12)); %m^5/N
%compliance for the thin tube
Cthintube = (1.5*l_s*(ri_s^3))/(h_s*E_s);
%total compliance of N segment (two parallel capacitors)
CM = ((Csensor)+(Cb));
%and resistance of
Rs = (8*l_s*u)/(pi*(ri_s^4));
%Fluid inertia is L
Ls=(d*l_s)/(pi*(ri_s)^2);

N=1;
M=5;
%set values for circuit simulation proccess:
%run the model for T time
T=10;
%in time steps of
dt=0.0001;
%excitation of the circuit with a step wave / Pressure inlet 
Pin=1; %Pa

%set matrix: rows represents time domain and columns represnt the n segment of
%in the model above
P=zeros((T/dt),N+M+1);
Q=zeros((T/dt),N+M+1);

%initialization stage:

%stimulate the circuit with a step for the voltage (Pressure-inlet
%modeling)
P(:,1)=Pin;
P(1,3)=0;
%state that we stimulate with zero current (flow modeling) excitation for the initial flow 
Q(:,:)=0;
if N==1 && M ==1 %Model mekubatz
    Qm=zeros(T/dt,2);
    for t=2:(T/dt)
        P(t,2) = Pin-((Rs+Rb)*Qm(t))-((Ls+Lb)*(Qm(t))-Qm(t-1))/dt;
        Qm(t) = (CM*((P(t,2))-P(t-1,2))/dt);
    end
    Pout = (P(:,2));
    lengthPout=length(Pout);
    time=(0:(T/(length(Pout)-1)):10);  
    logtime=log10(time+1);
    figure;
    semilogx(time,Pout)
    hold on
    xlabel('Time [Sec]')
    ylabel('Censor Pressure [Pa]')
    title(['Pressure measured in the transducer | Collected Model @ N=' num2str(N) ' M=' num2str(M)])
    figure(2)
    subplot(211)
    Fr=1/T;
    t=(0:length(Pout)-1)*T;
    Y=fft(Pout);
    P2 = abs(Y/length(Pout)-1);
    %focus on positive side of X-plane (sumetric to negetive)
    P1 = P2(1:lengthPout/2+1);
    P1(2:end-1) = 2*(P1(2:end-1));
    f= Fr*(0:(length(Pout)/2))/length(Pout);
    semilogx(f,P1)
    %plot(f,P1)
    title('Single-Sided Amplitude Spectrum of Pout(t)')
    xlabel('f (Hz)')
    ylabel('|Pout(f)|')
    %axis([0 max(f) min(P1) max(P1)])
    subplot(212)
    P1db=20*log10(abs(P1));
    semilogx(f,P1db)
    %plot(f,P1db)
    title('Single-Sided Amplitude Spectrum of Pout(t)')
    xlabel('f (Hz)')
    ylabel('|Pout(DB)|')
    %axis([0 max(f) min(P1db) max(P1db)])
    
    %as reference:
    syms s
    V=(1/(Lb+Ls)*CM)/((s^2)+((Rb+Rs)/((Lb+Ls))*s)+(1/(Lb+Ls)*CM));
    ilaplace(V);
    simplify(ilaplace(V));
    s=tf('s');
	H=(1/(Lb+Ls)*CM)/((s^2)+((Rb+Rs)/((Lb+Ls))*s)+(1/(Lb+Ls)*CM));
    figure(3)
    impulse(H);
    figure(4)
    bode(H);
else

    %Circuit is running:
    %start running on time-domain (i.e. lets build the columns of P & Q)
    for t=2:(T/dt)
        %KVL KCL on segment 1 of the model - step wave excitation (for all t,

        %segment 1 pressure is value Pi=1)
        %%P(t,1)=Pin;
        %%Q(t,1) = Q(t,1)-(Cthintube*((P(t,1))-P(t-1,1))/dt);
        %%P(t,1) = P(t,1)-(Rb*Q(t,1))-(Lb*((Q(t,1)-Q(t-1,1))/dt));

        %for each time step in the time domain, lets set values on all the
        %segments (i.e. lets build the rows of P & Q) - KVL & KCL for i-th segment
         %first part - thin tube
            for i=2:N
                P(t,i) = P(t,i-1)-(Rs*Q(t,i-1))-(Ls*(Q(t,i-1))-Q(t-1,i-1))/dt;
                Q(t,i) = Q(t,i-1)-(Cthintube*((P(t,i))-P(t-1,i))/dt);
            end
         %second part - thick tube
            for i=N+1:N+M
                P(t,i) = P(t,i-1)-(Rb*Q(t,i-1))-(Lb*(Q(t,i-1))-Q(t-1,i-1))/dt;
                Q(t,i) = Q(t,i-1)-(Cb*((P(t,i))-P(t-1,i))/dt);
            end
         %deal with Segment M seperatly, with his own Capacitor (thick last segment parallel to transducer).
            P(t,N+M+1) = P(t,N+M)-(Rb*Q(t,N+M))-(Lb*(Q(t,N+M))-Q(t-1,N+M))/dt;
            Q(t,N+M+1) = Q(t,N+M)-(CM*((P(t,N+M+1))-P(t-1,N+M+1))/dt);
    end


    Pout = (P(:,N+M+1))';
    %plotting and proccessing:
    %---------------------------
        %plot step response as function of N

    lengthPout=length(Pout);
    time=(0:(T/(length(Pout)-1)):10);  
    logtime=log10(time+1);
    figure;
    semilogx(time,Pout)
    hold on
    xlabel('Time [Sec]')
    ylabel('N-th segment Pressure [Pa]')
    title(['Pressure measured in the transducer @ N=' num2str(N) ' M=' num2str(M) 'for Pin=' num2str(Pin)])
    %zoom in on the steady state:
    %axis([0 0.001 min(Pout) max(Pout)])

        %...add more plotting here...

        %plot step response in frequencey domain as function of N

    %For Length of Pout equispaced points of Pout sampled at Fs Hz
    %(Square brackets indicate continuous time and frequency functions, Round brackets indicate discrete time and frequency functions):

    Fs=lengthPout/T; % Time sample rate, spaced by dt
    t = dt*(0:lengthPout-1); % Sampling times t(n) = dt*(n-1), n = 1:(N+M).
    %Pout(1:lengthPout)  Sampled function values x(n) = x[t = t(n)]
    T = (lengthPout)*dt; % Period of periodic reconstruction poutr =ifft(fft(pout))
                         % i.e., xr(n+N) = xr(n) corresponding to xr[t+T] = xr[t]
    Poutfft = fft(Pout); % Discrete Fourier Transform of Pout
    df = Fs/(lengthPout); % Frequency sample spacing (df = 1/T)
    f = df*(0:lengthPout-1); % Sampled frequencies f(n) = df*(n-1), n = 1:lengthPout.
    Poutfft(1:(lengthPout)); % Transform function values X(n) = X[f = f(n)]
    Fs = lengthPout*dt; % Transform period (i.e., X[f+Fs] = X(f);
                          % corresponding to X(n+lengthPout) = X(n);
    Poutb = fftshift(Poutfft); % Bipolar frequency version defined over
    fb = f-df*ceil((lengthPout-1)/2); % fb = df*[-(N+M+1)/2 : (lengthPout)/2-1] for (N+M+1) even
                                      % fb = df*[-(N+M+1)/2 : (lengthPout-1)/2]

    figure(2)
    subplot(221)
    plot(fb,real(Poutb))
    xlabel('Frequencie [Hz]')
    ylabel('Real part - Pout')
    axis([0 max(fb) min(real(Poutb)) max(real(Poutb))])
    subplot(222)
    plot(fb,imag(Poutb))
    xlabel('Frequencie [Hz]')
    ylabel('Imaginery pary - Pout')
    axis([0 max(fb) 0 max(imag(Poutb))])
    subplot(223)
    PoutbDB = 20*log10(abs(Poutb));
    plot(fb,PoutbDB)
    xlabel('Frequencie [Hz]')
    ylabel('Amplitude - Pout (db)')
    axis([0 max(fb) 0 max(PoutbDB)])
    subplot(224)
    plot(fb,angle(Poutb))
    xlabel('Frequencie [Rad/Sec]')
    ylabel('Phase - Pout [deg]')
    axis([0 max(fb) min(angle(Poutb)) max(angle(Poutb))])
    hold on

         %lets try in another way

    figure(3)
    subplot(411)
    Fr=1/T;
    t=(0:lengthPout-1)*T;
    Y=fft(Pout);
    P2 = abs(Y/lengthPout-1);
    %focus on positive side of X-plane (sumetric to negetive)
    P1 = P2(1:lengthPout/2+1);
    P1(2:end-1) = 2*(P1(2:end-1));
    f= Fr*(0:(lengthPout/2))/lengthPout;
    plot(f,P1)
    title('Single-Sided Amplitude Spectrum of Pout(t)')
    xlabel('f (Hz)')
    ylabel('|Pout(f)|')
    axis([0 max(f) min(P1) max(P1)])
    subplot(412)
    P1db=20*log10(abs(P1));
    plot(f,P1db)
    title('Single-Sided Amplitude Spectrum of Pout(t)')
    xlabel('f (Hz)')
    ylabel('|Pout(DB)|')
    axis([0 max(f) min(P1db) max(P1db)])
    subplot(413)
    P4 = angle(Y/lengthPout-1);
    P3 = P4(1:lengthPout/2+1);
    P3(2:end-1) = 2*(P3(2:end-1));
    plot(f,P3)
    title('Single-Sided Phase Spectrum of Pout(t)')
    xlabel('f (Rad/Sec)')
    ylabel('|Phase(deg)|')
    axis([0 max(f) min(P1db) max(P1db)])
    %zoom at crazy part of phase graph, non-linear pahse shit
    subplot(414)
    semilogx(f,P3);
    title('Zoomed-in Phase Spectrum of Pout(t)')
    xlabel('f (Rad/Sec)')
    ylabel('|Phase(deg)|')


        %plot bandwith with 5% accuracy as function of N

        %%plot rise time as function of N

        %plot delay time as function of N

        %plot time till steady state as function of N

        %...add some proccessing to optimize R as a vector, C as a vector for the different segments (find optimal R and C???)....
    %end
end