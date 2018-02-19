%Collected model for a pressure transducer
%By: Gil Abir Cavalero & Meital Cohen-Adiv

%purpose: modeling a long thick tube with a thin tube connected to a pressure transducer
%         and compare different amount of N segments to indicate the performance of a
%         concatenated model of N tube segments, over a collected model of a tube:

%the model: Pin-|--/\/\/\--SSS--|-/\/\/\--SSS----...--/\/\/\--SSS-|-Pout
%               |               |                |                | 
%               |_______________|________________|..._____________|
%-------------------------------------------------------------------------

%plotting and proccessing:
%lets plot Pout - represents the Pressuse outlet for the transducer

%for n=1:3
   %for Nloop=1:3
      M=6;
     % N=50*Nloop;
      %subplot(5,5,5*(n-1) + i), 
      TubeTransducerModeling(100,M)
 %  end
%end
