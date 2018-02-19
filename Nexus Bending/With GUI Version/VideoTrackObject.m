function VideoTrackObject(handles)
%% Track an Object Of Interest in a video (avi)
%% Create System objects for reading and displaying video and for drawing a bounding box of the object. 
[filename,pathname] = uigetfile({'*.*'},'Open Directory');
if isequal(filename,0) || isequal(pathname,0)
    return
end
file=[pathname filename];
videoFileReader = vision.VideoFileReader(file);
videoPlayer = vision.VideoPlayer('Position', [100, 100, 680, 520]);
%% Read the first video frame, which contains the object, in order to define the region.
objectFrame = step(videoFileReader);
%% Select the object region using a mouse. The object must occupy the majority of the region. 
 figure; imshow(objectFrame);
 objectRegion=round(getPosition(imrect));
 close;
%% Show initial frame with a red bounding box.
objectImage = insertShape(objectFrame, 'Rectangle', objectRegion,'Color', 'red'); 
figure(1); imshow(objectImage); title('Red box shows object region');
close;
%% Detect interest points in the object region.
points = detectMinEigenFeatures(rgb2gray(objectFrame), 'ROI', objectRegion);
%% Display the detected points.
pointImage = insertMarker(objectFrame, points.Location, '+', 'Color', 'blue');
% figure(2);
% subplot(3,2,5);
% imshow(pointImage), title('Detected interest points');
%% Create a tracker object.
tracker = vision.PointTracker('MaxBidirectionalError', 1);
%% Initialize the tracker.
initialize(tracker, points.Location, objectFrame);
%% Read, track, display points, and results in each video frame.
video = VideoReader(file);
NumOfFrames = ceil(video.FrameRate*video.Duration);
XPosMat = cell(NumOfFrames,1);
YPosMat = cell(NumOfFrames,1);
iteration = 1;
while ~isDone(videoFileReader)
      frame = step(videoFileReader);
      [points, validity] = step(tracker, frame);
      XPosMat{iteration}=points(:,1);
      YPosMat{iteration}=points(:,2);
      out = insertMarker(frame, points(validity, :), '+');
      step(videoPlayer, out);
      iteration = iteration + 1;
      if ~any(validity)
         break;
      end  
end

%% Release the video reader and player.
release(videoPlayer);
release(videoFileReader);
closepreview;

%% Calculate Movements of tracked points 
CalcMovements( XPosMat,YPosMat,points,NumOfFrames,iteration,objectRegion,pointImage,handles)
end