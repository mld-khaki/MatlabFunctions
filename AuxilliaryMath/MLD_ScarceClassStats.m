function [Stats,Score] = MLD_ScarceClassStats(Classes,Predictions)

UnqCls = unique(Classes(~isnan(Classes)));
UnqClsCnt = zeros(size(UnqCls));

Stats= [];
for iCtr=1:length(UnqCls)
    Stats(iCtr).Class = UnqCls(iCtr);
    Stats(iCtr).Count = nansum(Classes == UnqCls(iCtr));
    
    Index = Classes == UnqCls(iCtr);
    Stats(iCtr).Identified = nansum(Predictions(Index) == UnqCls(iCtr));
    Stats(iCtr).IDRatio = Stats(iCtr).Identified/Stats(iCtr).Count;
end

Score = 0;

for iCtr=1:length(Stats)
    if Stats(iCtr).IDRatio == 0
        Score = Score - 20;
    elseif Stats(iCtr).IDRatio < 0.1
        Score = Score - 5;
    elseif Stats(iCtr).IDRatio < 0.25
        Score = Score - 1;
    elseif Stats(iCtr).IDRatio < 0.4

    elseif Stats(iCtr).IDRatio < 0.5
        Score = Score + 1;
    elseif Stats(iCtr).IDRatio < 0.75
        Score = Score + 1.5;
    elseif Stats(iCtr).IDRatio < 0.95
        Score = Score + 1.75;
    else
        Score = Score + 2;
    end
end
end