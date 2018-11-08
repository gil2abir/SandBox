function [gratedStructure] = dammannGrating(inImg, n, scale, shift, grateWidth)
%DAMMANGRATING takes an image and model parameters and perform optical
%damman grating transformation


%Create the grated matrix
%THE SARIG WILL LOOK LIKE: [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0]
%                          [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0]
%                          ...
%                          ...
%                          ...
%                          [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0]
%
%                          [<------>| <--> | <---->|..............]
%                            shift  | grateWidth
%
%                          for simplicity, we say we always start with a
%                          "shift" - no slit.
%

numSlits = size(inImg,1)/(grateWidth+shift);
%if any space left, add the remainder to a slit
%    numSlits = numSlits + mod(size(inImg,1)- numSlits, grateWidth);

if(size(inImg,1)- numSlits < grateWidth)
    numSlits = numSlits + 1;
end


g = repmat([zeros(1, shift), ones(1,grateWidth)], 1, numSlits-1);
g = [g, [ones(1, grateWidth), zeros(1, size(inImg, 2) - g - grateWidth)]];
G = repmat(g, size(inImg, 2), 1);

%...
%...

imgOut = G.*inImg;


end

