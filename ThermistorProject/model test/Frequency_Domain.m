function [smoothed_fft_signal,f] =Frequency_Domain(signal,sample_rate)

%Identifing a new input length that is the next power of 2 from the original signal length. 
%And padding the signal with trailing zeros in order to improve the performance of fft.
%nextpow2 pads the signal you pass to fft.
NFFT = 2 ^ nextpow2(length(signal));

%Converting to the freq domain
Y = fft(double(signal), NFFT) / length(signal);
 
% Vector containing frequencies in Hz
f = (double(sample_rate) / 2 * linspace(0, 1, NFFT / 2))'; 
 
% Vector containing corresponding amplitudes
power = 2 * abs(Y(1:(NFFT / 2)));
 
smoothed_fft_signal=smooth(power(:),5);
end
