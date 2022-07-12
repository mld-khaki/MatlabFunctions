function [ Status ] = MLD_FigureSaver__v6p0( FigureHandle , SavePath , varargin)
%function [ Status ] = FigureSaverV5p1( FigureHandle , SavePath ,)
%       Input Parameters
%               Position            [Left, Bottom, Width, Height]
%                                   i.e. ...,"Position",[0, 0, 900, 750],...
%
%               MFileName           String name of the generating mfile
%               Title
%               suptitle            Super subtitle for plot with multiple subplots
%               Label               Figure label in Latex,"FileName",...
%               PaperSize           [Left, Buttom, Width, Height]
%               PaperPosition       [Left, Buttom]
%               PlotData            Plot data variable
%               LatexFilePath       The path that you want the latex file to be saved int
%               Available Extensions
%                                   "PNG","PDF","EPS","FIG","MAT"
%                                   i.e. ...,"PNG","true",...
%
%               RemoveBorders       RGB value of background to remove the borders of
%                                   picture or 0 for black and white
%                                   i.e. ...,"RemoveBorders",[r g b],...
%                                   i.e. ...,"RemoveBorders",0,...
%
%                   Position = [200, 100, 1024, 768];
%
%                   MLD_FigureSaver__v6p0(FigureHandle,".","filename",sprintf("Figure_%03u",ClsCtr),...
%                       "Position",Position,"RemoveBorders",255*[1 1 1],"BorderSize",25);
%
%


try
    InputData = struct;

    if SavePath(end) == "."
        SavePath = SavePath + "\\";
    end
    SavePath = string(SavePath);


    InputData.Position = FigureHandle.Position;

    Status = 1;
    InputData.MFileName = "";
    InputData.FileName = sprintf("CurrentFigure_%4u_%2u_%2u__%2u_%2u",year(now()),month(now()),day(now()),hour(now()),minute(now()));
    InputData.Label = "Fig"+ InputData.FileName;
    InputData.PaperSize = [];
    InputData.PaperPosition = [];
    InputData.PlotData = nan;
    InputData.LatexFilePath = InputData.FileName;
    InputData.PNG = "true";
    InputData.PDF = "true";
    InputData.EPS = "false";
    InputData.FIG = "true";
    InputData.TEX = "false";
    InputData.SVG = "false";
    InputData.Data = [];
    InputData.RemoveBorders = nan;
    InputData.BorderSize = 1;

    if nargin < 2
        error("Minimum two arguments is required");
        Status = 0;
    end

    InputVariables = ["Position","MFileName","Title","suptitle","Label","FileName",...
        "PaperSize","PaperPosition","PlotData","LatexFilePath","PNG","PDF","EPS","FIG","SVG","MAT","RemoveBorders","BorderSize"];
    CompiledVariables = 0;
    if nargin > 2
        for aCtr=1:2:length(varargin)
            for iCtr=1:length(InputVariables)
                if strcmpi(InputVariables{iCtr},varargin{aCtr}) == 1
                    InputData.(InputVariables{iCtr}) = varargin{aCtr+1};
                    CompiledVariables = CompiledVariables + 1;
                end
            end
        end
    end

    if (nargin ~= (2+2*CompiledVariables))
        error("At least one of the arguments does not have a value");
    end


    set(FigureHandle,"paperunits","centimeters");
    figure(FigureHandle);
    if ~isnan(InputData.Position)
        set(FigureHandle, "Position",      InputData.Position);
        set(FigureHandle, "OuterPosition", InputData.Position);
    end

    if ~isnan(InputData.PaperSize)
        set(FigureHandle,"papersize",InputData.PaperSize);
        set(FigureHandle,"paperposition",[0,0,InputData.PaperSize]);
    end

    set(FigureHandle,"PaperOrientation","landscape");
    set(FigureHandle,"PaperUnits","centimeters");
    % set(FigureHandle,"PaperPosition",[0.1,0.25,10.8,8.0]);

    if isfield(InputData,"Title")
        title(InputData.Title);
    end
    if isfield(InputData,"suptitle")
        suptitle(InputData.suptitle);
    end

    if strcmpi(InputData.EPS,"true") == 1
        print("-depsc2","-r600",SavePath + InputData.FileName + ".eps");
    end

    if strcmpi(InputData.PNG,"true") == 1
        IMGPath = SavePath + InputData.FileName + ".png";
        print("-dpng","-r200",IMGPath);
        if ~isnan(InputData.RemoveBorders)
            FigSaver_RemoveBorders(IMGPath,InputData);
        end
    end

    if strcmpi(InputData.PDF,"true") == 1
        %     print("-dpdf",[SavePath InputData.FileName ".pdf"],"-bestfit");
        print("-dpdf",SavePath + InputData.FileName + ".pdf","-bestfit");
    end

    if strcmpi(InputData.SVG,"true") == 1
        print("-dmeta"  , SavePath + InputData.FileName + ".svg");
    end

    if strcmpi(InputData.FIG,"true") == 1
        saveas(FigureHandle,SavePath + InputData.FileName + ".fig","fig");
    end

    Extensions = ["FIG","PNG","EPS","PDF"];
    if ~isnangeneral(InputData.PlotData)
        Extensions(end+1) = "mat";
        save(SavePath + InputData.FileName + ".mat",FigureHandle.Children.Children);
    end

    if ~isempty(InputData.MFileName)
        if exist(InputData.MFileName + ".m","file")
            Extension_List(end+1) = InputData.MFileName + ".m";
        end
    end

    if strcmpi(InputData.TEX,"true") == 1
        if ~isnan(InputData.LatexFilePath)
            Extensions(end+1) = "tex";
            fid = fopen(SavePath + InputData.FileName + ".tex","w");
            fprintf(fid,"\\begin{figure}[ht]\n");
            fprintf(fid,"\\centering\n");
            fprintf(fid,"\\includegraphics[width = \\FigConsVsHourWidth]{%s%s}\n",IndexData.LatexFilePath,InputData.FileName);
            fprintf(fid,"\\caption{%s}\n",Caption);
            fprintf(fid,"\\label{%s}\n",Label);
            fprintf(fid,"%%Results are generated by: \n%%%s.m script file\n%%at %s, on computer: %s\n",MFileName,datestr(now()),getComputerName());
            fprintf(fid,"\\end{figure}");
            fclose(fid);
        end
    end

    Extension_List = "";
    for eCtr=1:length(Extensions)
        if strcmpi(InputData.(Extensions(eCtr)),"true")==1
            Extension_List(end+1) = SavePath + InputData.FileName + "." + lower(Extensions(eCtr));
        end
    end
    Extension_List(1) = [];

    for eCtr=length(Extension_List):-1:1
        if isempty(Extension_List(eCtr))
            Extension_List(eCtr) = [];
        end
    end

    zip(SavePath + InputData.FileName + ".zip",Extension_List);
    %     zip([SavePath InputData.FileName "mfile.zip"],);
    Extensions(end+1) = "fig";
    for fCtr=1:length(Extensions)
        FileStr = SavePath + InputData.FileName + "." + Extensions(fCtr);
        if strcmpi(Extensions(fCtr),"png") == 0 && exist(FileStr,"file")
            delete(FileStr);
        end
    end

    Status = 1;
catch ME
    1
end

end

function name = getComputerName()
[ret, name] = system("hostname");

if ret ~= 0
    if ispc
        name = getenv("COMPUTERNAME");
    else
        name = getenv("HOSTNAME");
    end
end
name = strtrim(lower(name));
end

function Out = isnangeneral(Input)
if isstruct(Input)
    Out = 0;
else
    Out = isnan(Input);
end
end

function FigSaver_RemoveBorders(IMGPath,InputData)
FigureData = imread(IMGPath);
if length(InputData.RemoveBorders) == 1
    BW = 1;
    Treshold_or_BWColor = 1;
else
    BW = 0;
    Treshold_or_BWColor = InputData.RemoveBorders;
end

if BW == 1
    Treshold_or_BWColor = 0.9*nanmax(nanmax(nanmax(FigureData)));
elseif nargin < 1
    error("Background Color is required in colored mode");
end

ObstacleFound = 0;
ScrWidth = 60;
fprintf("\nRemoving from Left");
LeftIndex = 1;
while(ObstacleFound ~= 1)
    for yCtr=1:size(FigureData,1)
        if ConditionFoundObstacle(FigureData(yCtr,LeftIndex,:),BW,Treshold_or_BWColor)
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
        if ConditionFoundObstacle(FigureData(yCtr,end-RightIndex,:),BW,Treshold_or_BWColor)
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
        if ConditionFoundObstacle(FigureData(TopIndex,xCtr,:),BW,Treshold_or_BWColor)
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
        if ConditionFoundObstacle(FigureData(end-ButtomIndex,xCtr,:),BW,Treshold_or_BWColor)
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

imwrite(FigureData,IMGPath);
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


