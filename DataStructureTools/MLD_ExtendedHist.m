function Out = ExtendedHist(Input, varargin)
Variables = {'NumOfBins','FigureHandle','Grid','Item','Title'};
Options = [];
Options.NumOfBins = [];
Options.FigureHandle = [];
Options.Grid = true;
Options.Item = 'Item';
Options.Title = '';
for iCtr=1:2:length(varargin)
    for vCtr=1:length(Variables)
        if strcmpi(varargin{iCtr},Variables{vCtr}) == 1
            Options.(Variables{vCtr}) = varargin{iCtr+1};
        end
    end
end

if isempty(Options.FigureHandle)
    Options.FigureHandle = figure;
else
    figure(Options.FigureHandle);
end
Out = Options.FigureHandle;

if ~isempty(Options.NumOfBins)
    [HistAr,XAr] = hist(Input,Options.NumOfBins);
else
    [HistAr,XAr] = hist(Input);
end


bar(XAr,HistAr);
if Options.Grid == true
    grid on;
end
xlabel(['Range of values of '  Options.Item 's']);
ylabel(['Number of ' Options.Item 's in each bin']);
title(Options.Title);
FigureSetter(Options.FigureHandle);

    function FigureSetter(FigH)
        set(FigH, 'Position',      [100, 100, 600, 450]);
        set(FigH, 'OuterPosition', [100, 100, 600, 450]);
        
    end
end

