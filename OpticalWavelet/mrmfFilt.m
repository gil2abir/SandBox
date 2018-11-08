function [imOut] = mrmfFilt(imageArray)
%PHASEFILT takes an array of images and implements the non-linear phase filter
%step described in the formulation.

N = size(imageArray(:,:,1),1);
mrmf = zeros(N,N);

for ui = 1:N
    for vi = 1:N
        %Implement MRMF formulation here!!
    end
end


end

