function LastPoint = MLD_PrintPercentPoints(InpCtr,MaxCtr,TotPoints,LastPoint)
if LastPoint == TotPoints+1
    return;
end
CurPoint = max([floor((InpCtr*TotPoints)/MaxCtr),LastPoint]);

if CurPoint > LastPoint
    for pCtr=1:floor(CurPoint-LastPoint+1), fprintf('.');end
end

if CurPoint >= TotPoints 
    fprintf('\n');
    LastPoint = TotPoints+1;
elseif LastPoint == 0
    LastPoint = 1;
    fprintf('\n.');
else
    LastPoint = CurPoint;
end
end