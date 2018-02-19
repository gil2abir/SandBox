function CalcMovements( XPosMat,YPosMat,points,NumOfFrames,iteration,objectRegion,pointImage)
%   calculate the movements of the tracked points and show results
%% Calculate Movements & plot 

XMovMat=zeros(length(points),iteration-1);
YMovMat=zeros(length(points),iteration-1);
for i=2:iteration-1
        XMovMat(:,i-1) = cell2mat(XPosMat(i,1))-cell2mat(XPosMat(i-1,1));
        YMovMat(:,i-1) = cell2mat(YPosMat(i,1))-cell2mat(YPosMat(i-1,1));
end

%sum movement of time steps per each half cycle for each axes
XsumMove=zeros(size(XMovMat,1),length(XMovMat));
YsumMove=zeros(size(YMovMat,1),length(YMovMat));
for j=1:size(XMovMat,1)
    Xpoint_sign_change=find(XMovMat(j,1:end-1).*XMovMat(j,2:end)<0);
    Ypoint_sign_change=find(YMovMat(j,1:end-1).*YMovMat(j,2:end)<0);
    for i=1:length(Xpoint_sign_change)
        XsumMove(j,i)=sum(XMovMat(j,i:Xpoint_sign_change(i)));
    end
    for i=1:length(Ypoint_sign_change)
        YsumMove(j,i)=sum(YMovMat(j,i:Ypoint_sign_change(i)));
    end
end
XsumMove(~any(XsumMove,2),:)=[];
%XsumMove(:,~any(XsumMove,1))=[];
absXsumMove=abs(XsumMove);
YsumMove(~any(YsumMove,2),:)=[];
%YsumMove(:,~any(YsumMove,1))=[];
absYsumMove=abs(YsumMove);

%calibration of pixels to mm
calib_val=inputdlg({'X calibration','Y Calibration','Camera Distance'}, 'Calibration Values', [1 12; 1 12; 1 12]);
calib_val=cellfun(@str2num,calib_val);
ObjectHeight=objectRegion(4)-objectRegion(2);
ObjectWidth=objectRegion(1)-objectRegion(3);
dx=calib_val(1)/ObjectWidth;
dy=calib_val(2)/ObjectHeight;


%figure;
meanLocationX=cellfun(@mean,XPosMat, 'UniformOutput', false);
meanLocationY=cellfun(@mean,YPosMat, 'UniformOutput', false);
meanLocationX(cellfun(@isnan,meanLocationX))=[];
meanLocationY(cellfun(@isnan,meanLocationY))=[];
meanLocationX=cell2mat(meanLocationX);
meanLocationY=cell2mat(meanLocationY);

meanLocationXmm=meanLocationX.*dx;
meanLocationYmm=meanLocationY.*dy;

MeanXpointsmov=sum(XsumMove,2)./sum(XsumMove~=0,2);
absMeanXpointsmov=sum(absXsumMove,2)./sum(absXsumMove~=0,2);
MeanYpointsmov=sum(YsumMove,2)./sum(YsumMove~=0,2);
absMeanYpointsmov=sum(absYsumMove,2)./sum(absYsumMove~=0,2);

%axes(handles.axes1)
%subplot(3,2,5);
%imshow(pointImage), title('Detected interest points');
subplot(3,2,[1:2 3:4]);
plot(meanLocationXmm-min(meanLocationXmm),meanLocationYmm-min(meanLocationYmm),'b--o')
title('median position of points (rest starting position as (0,0))')
xlabel('X coordinate [mm]')
ylabel('Y coordinate [mm]')
hold on;
Cordinates=[meanLocationXmm-min(meanLocationXmm),meanLocationYmm-min(meanLocationYmm)];
CorDis=pdist(Cordinates,'euclidean');
CorDisMat=squareform(CorDis);
[p1,p2]=find(CorDisMat==max(CorDisMat(:)));
maxCordX=[Cordinates(p1,1) Cordinates(p2,1)];
maxCordY=[Cordinates(p1,2) Cordinates(p2,2)];
plot(maxCordX,maxCordY)
pos=[maxCordX;maxCordY];
dis=dist(pos);
str=['Maximum Movements are: X=',num2str(abs((pos(1,2)-pos(1,1)))),'mm Y=',num2str(abs(pos(3,2)-pos(3,1))),'mm Magnitude=',num2str(dis(1,2)),'mm'];
legend('cycling movements of mean tracked points',str)
%annotation('textbox',dim,'string',str,'FitBoxToText','on');
%disMid=dis(1,2)/2;
%text(disMid,disMid,str,'HorizontalAlignment','right')

subplot(3,2,6)
compass(meanLocationXmm-min(meanLocationXmm),meanLocationYmm-min(meanLocationYmm))
title('Magnitude (Size of arrow) and direction of mean position')

end

