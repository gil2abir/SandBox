function [HRV,outRR]=algo_utils_berger(inRR,Fs)
% Resampling with the Berger algorithm
% [HRV,RRI] = algo_utils_berger(RRI, Fs)
% [HRV,RRI] = algo_utils_berger(ONSET, Fs)
% 
% RRI 	R-to-R interval 
% ONSET onset time QRS-complex
% Fs	target sampling rate
% HRV 	heart rate variability sampled with Fs
% RRI	R-to-R interval sampled with Fs
%


if ~any(diff(inRR)<0),	
        on = inRR(:)-min(inRR);
else		% calculate onset of bursts 
        on = cumsum([0;inRR(:)]);
end;

%T=1/Fs;

N=ceil(max(on)*Fs);
HRV=zeros(N,1);

on = [on; nan] * Fs;

IX = 1;
%on,break,
for n=1:N,
	while (on(IX+1)<(n-1)), IX=IX+1; end;
        ix=IX+1;
        CONT=1;
        while CONT,
                
		% 1st case: RR interval is totally encompassed by sample window
	        if     ((on(ix-1) >= (n-1)) && (on(ix) <= (n+1))),
                        HRV(n) = HRV(n) + 1;
		% 2nd case: RR interval partially overlaps beginning of sample window
	        elseif ((on(ix-1) <  (n-1)) && (on(ix) < (n+1))),
                        HRV(n) = HRV(n) + (on(ix)-(n-1))/(on(ix)-on(ix-1));
		% 3rd case: RR interval partially overlaps the end of sample window
	        elseif ((on(ix-1) > (n-1)) && (on(ix) >  (n+1))),
                        HRV(n) = HRV(n) + ((n+1) - on(ix-1))/(on(ix)-on(ix-1));
		% 4th case: RR interval totally overlaps the sample window
	        elseif ((on(ix-1) <=  (n-1)) && (on(ix) >=  (n+1))),
                        HRV(n) = HRV(n) + 2/(on(ix)-on(ix-1));
                else
                        disp([ix,on(ix-1)/Fs,on(ix)/Fs, n, (n+1),HRV(n)])                       
                        fprintf(2,'Warning %s: Invalid program state',upper(mfilename));
                        HRV(n) = nan;
                end;
                if (on(ix)<(n+1)),%(on(ix-1)<(n+1)*T), 
                        ix = ix+1;
                else
                        CONT=0;
                end;
        end;
end;        

inRR=(2*max(on)/N/Fs)./HRV;
outRR=inRR;
%Y=Fs/2*N/max(on(1:length(on)-1))*Y;
HRV=60./inRR;