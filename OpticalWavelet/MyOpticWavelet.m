function  outImg = MyOpticWavelet(inImg)
%MYOPTICWAVELET Will take an image input, and using configuration
%parameters defined in Config, will do an optical wavelet numerical flow on
%the image
%   Input:
%           inImg =  path to image file in path
%   Output:
%           outImg = the convulved image with the optical wavelet
%                    transformation.
%
%   Internal Simulation Parameters (configurable):
%           n - 
%           b1 - 
%           b2 - 
%           etc...


%% Define Some Defaults
%Default image source if no input was requested
if(nargin<1)
    inImg = imread('cameraman.tif');
else
    inImg = imread(inImg);
end

%% Config
%DG
model = struct();
model.DG.n = 9;
model.DG.shift = 2;
model.DG.slitWidth = 1; 

%FFT-Lenses
model.FFTLENS.f11 = f11;
model.FFTLENS.f12 = f12;
model.FFTLENS.f21 = f21;
model.FFTLENS.f22 = f22;

%Show Original Image
figure;image(inImg);title('Original Image')

%% Preprocess Image

%if image is not a square, crop it by the smallest dimension.
N = min(size(inImg,1),size(inImg,2));
procImg = inImg(1:N,1:N);
%Add here preprocess steps if needed.
%Resizing\cropping\color-2-gray\histogram equalizzation\etc'...
procImg = inImg;
figure;image(procImg);title('Pre-Processed Image')


%% Pass image through the Dammann Grating step
gratedArray = dammanGrating(procImg, mode.DG.n, model.DG.initScale, model.DG.shift, ...
                    model.DG.slitWidth);

figure;
for iImg=1:model.DG.n
    subplot(iImg,3,3)
    image(gratedArray(:,:,iImg))
end

%% Pass the output of the DG through 2 lenses (modelling the FFT process?)
for iImg=1:model.DG.n
    transformedArray(:,:,iImg) = fftLenses(gratedArray(:,:,iImg), modelParameters);
end

%% Pass the grated fourier transformed images through the phase-differentior filter
outImg = phaseFilt(transformedArray);



%% Some Post-Process steps if such needed



%% Visualization and summary
figure;image(imOut);title('Final Image')



end

