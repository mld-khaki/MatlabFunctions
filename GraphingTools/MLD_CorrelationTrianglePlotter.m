function Out = MLD_CorrelationTrianglePlotter(InputCorrelation,YLabels,XLabels)
FigH2 = figure;

PairwiseFeaturesPlot = InputCorrelation;
PairwiseFeaturesPlot(PairwiseFeaturesPlot == 0) = 1;
PairwiseFeaturesPlot = PairwiseFeaturesPlot  - nanmin(nanmin(PairwiseFeaturesPlot));
PairwiseFeaturesPlot = PairwiseFeaturesPlot ./ nanmax(nanmax(PairwiseFeaturesPlot));

for iCtr=1:size(PairwiseFeaturesPlot,1)
	for jCtr=iCtr:size(PairwiseFeaturesPlot,1)
		PairwiseFeaturesPlot(iCtr,jCtr) = nan;
	end
end

imagesc(PairwiseFeaturesPlot(end:-1:1,end:-1:1)');
grid on;

if nargin >= 2 
xticks(1:size(InputCorrelation,1));
xticklabels(XLabels(end:-1:1));
end

if nargin >= 3
	yticks(1:size(InputCorrelation,2));
	yticklabels(YLabels(end:-1:1));
end

axis square;
% title(TitleStr);

hold on;
BlackBlock = zeros(2,2,3);
for iCtr=1:size(PairwiseFeaturesPlot,1)
	for jCtr=iCtr:size(PairwiseFeaturesPlot,1)
		imagesc(BlackBlock,'YData', [iCtr-1 iCtr], 'XData', [jCtr jCtr+1])
	end
end
% CMapHandle.Label.Rotation = 90;
% FileName = sprintf('Transgenics_Pairwise_Correlation_Tops__CntOf_%u',SelectedClassifiersCount);
% MLD_FigureSaverV5(FigH2,'.','filename',FileName,...
% 	'Position',[0, 0, 1400, 750]);
% close(FigH2);
end