%// Define the x values
t = t1;
tMat = repmat(t, 1, 7); %// For plot3

%// Define y values
iteration = 0:1:6;
iterationMat = repmat(iteration, numel(t), 1); %//For plot3

%// Define z values

ThermMat = [T1 T2 T3 T4 T5 T6 T7]; %// For plot3

plot3(tMat, iterationMat, ThermMat, 'b'); %// Make all traces blue
grid;
xlabel('Time[s]'); ylabel('iteration [#]'); zlabel('Tthermistor[c]');
view(40,40); %// Adjust viewing angle so you can clearly see data