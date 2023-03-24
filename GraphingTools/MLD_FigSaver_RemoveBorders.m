function MLD_FigSaver_RemoveBorders(IMGPathOnly,IMGFile,InputData)
if ~exist('InputData','var')
    InputData = struct;
    InputData.RemoveBorders = 1;
    InputData.BorderSize = 25;
    InputData.BW = false;
    InputData.OutputFigureName = "_"+IMGFile;
end
IMGPath = IMGPathOnly + IMGFile;
IMGPathOut = IMGPathOnly + InputData.OutputFigureName;

FigureData = imread(IMGPath);
if length(InputData.RemoveBorders) == 1
%     BW = 1;
    Treshold_or_BWColor = 1;
else
%     BW = 0;
    Treshold_or_BWColor = InputData.RemoveBorders;
end

if InputData.BW == false
    Treshold_or_BWColor = 0.9*nanmax(FigureData(:));
% elseif nargin < 1
%     error("Background Color is required in colored mode");
end

ObstacleFound = 0;
ScrWidth = 60;
fprintf("\nRemoving from Left");
LeftIndex = 1;
while(ObstacleFound ~= 1)
    for yCtr=1:size(FigureData,1)
        if ConditionFoundObstacle(FigureData(yCtr,LeftIndex,:),InputData.BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        LeftIndex = LeftIndex + 1;
        fprintf(".");
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf("\n");
        end
    end
end
LeftIndex = nanmax([1,LeftIndex - InputData.BorderSize]);
FigureData = FigureData(:,LeftIndex:end,:);



ObstacleFound = 0;
fprintf("\nRemoving from Right");
RightIndex = 0;
while(ObstacleFound ~= 1)
    for yCtr=1:size(FigureData,1)
        if ConditionFoundObstacle(FigureData(yCtr,end-RightIndex,:),InputData.BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        RightIndex = RightIndex + 1;
        fprintf(".");
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf("\n");
        end
    end
end
RightIndex = nanmax([0,RightIndex - InputData.BorderSize]);
FigureData = FigureData(:,1:end-RightIndex,:);

ObstacleFound = 0;
fprintf("\nRemoving from Top");
TopIndex = 1;
while(ObstacleFound ~= 1)
    for xCtr=1:size(FigureData,2)
        if ConditionFoundObstacle(FigureData(TopIndex,xCtr,:),InputData.BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        TopIndex = TopIndex + 1;
        fprintf(".");
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf("\n");
        end
    end
end
TopIndex = nanmax([1,TopIndex - InputData.BorderSize]);
FigureData = FigureData(TopIndex:end,:,:);


ObstacleFound = 0;
fprintf("\nRemoving from Down");
ButtomIndex = 0;
while(ObstacleFound ~= 1)
    for xCtr=1:size(FigureData,2)
        if ConditionFoundObstacle(FigureData(end-ButtomIndex,xCtr,:),InputData.BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        ButtomIndex = ButtomIndex + 1;
        fprintf(".");
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf("\n");
        end
    end
end
ButtomIndex = nanmax([1,ButtomIndex - InputData.BorderSize]);
FigureData = FigureData(1:end-ButtomIndex,:,:);

imwrite(FigureData,IMGPathOut);
end

function Out = ConditionFoundObstacle(Input,BW,ThresholdOrColor)
if BW == 1 % Threshold based
    if Input(1) < ThresholdOrColor
        Out = 1;
    else
        Out = 0;
    end
else
    if sum(Input > ThresholdOrColor) == 3
        Out = 0;
    else
        Out = 1;
    end
end
end


