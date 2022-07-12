function IMG = RemoveBorders(Folder,InIMG,BW,Treshold_or_BWColor)
ExportFile = 0;
if ischar(InIMG)
    IMG = imread([Folder InIMG]);
    ExportFile = 1;
else
    IMG = InIMG;
end

if BW == 1
    Treshold_or_BWColor = 0.9*nanmax(nanmax(nanmax(IMG)));
elseif nargin < 3
    error('Background Color is required in colored mode');
end

ObstacleFound = 0;
ScrWidth = 60;
fprintf('\nRemoving from Left');
while(ObstacleFound ~= 1)
    for yCtr=1:size(IMG,1)
        if ConditionFoundObstacle(IMG(yCtr,1,:),BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        IMG = IMG(:,2:end,:);
        fprintf('.');
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf('\n');
        end
    end
end
ObstacleFound = 0;
fprintf('\nRemoving from Right');
while(ObstacleFound ~= 1)
    for yCtr=1:size(IMG,1)
        if ConditionFoundObstacle(IMG(yCtr,end,:),BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        IMG = IMG(:,1:end-1,:);
        fprintf('.');
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf('\n');
        end
    end
end
ObstacleFound = 0;
fprintf('\nRemoving from Top');
while(ObstacleFound ~= 1)
    for xCtr=1:size(IMG,2)
        if ConditionFoundObstacle(IMG(1,xCtr,:),BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        IMG = IMG(2:end,:,:);
        fprintf('.');
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf('\n');
        end
    end
end
ObstacleFound = 0;
fprintf('\nRemoving from Down');
while(ObstacleFound ~= 1)
    for xCtr=1:size(IMG,2)
        if ConditionFoundObstacle(IMG(end,xCtr,:),BW,Treshold_or_BWColor)
            ObstacleFound = 1;
        end
    end
    if ObstacleFound <= 0
        ObstacleFound = ObstacleFound - 1;
        IMG = IMG(1:end-1,:,:);
        fprintf('.');
        if (mod(ObstacleFound,ScrWidth) == 0)
            fprintf('\n');
        end
    end
end
if ExportFile == 1
    imwrite(IMG,[Folder 'brm_' InIMG]);
end

    function Out = ConditionFoundObstacle(Input,BW,ThresholdOrColor)
        if BW == 1 % Threshold based
            if Input(1) < ThresholdOrColor
                Out = 1;
            else
                Out = 0;
            end
        else
            if sum(Input == ThresholdOrColor) == 3
                Out = 0;
            else
                Out = 1;
            end
        end
    end
end



