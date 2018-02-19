function [fitresult, gof] = createFitCustomFunctionModel(t, Tc)
%CREATEFIT(T,TC)
%  Create a fit.


% Gil & Guy

%% Fit: 'Thermistor Model Fit'.
[xData, yData, weights] = prepareCurveData( t, Tc, t );

% Set up fittype and options.
ft = fittype( '(1-a*exp(-b*t))+(1-c*exp(-d*t))+g', 'independent', 't', 'dependent', 'Tc' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Robust = 'LAR';
opts.StartPoint = [0.959291425205444 0.547215529963803 0.138624442828679 0.149294005559057 0.840717255983663];
opts.Weights = weights;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'Thermistor Model Fit' );
h = plot( fitresult, xData, yData, 'predobs' );
legend( h, 'Tc vs. t with t', 'Thermistor Model Fit', 'Lower bounds (Thermistor Model Fit)', 'Upper bounds (Thermistor Model Fit)', 'Location', 'NorthEast' );
% Label axes
xlabel t
ylabel Tc
grid on


