function [EqColor,EqCompColor] = MLD_GetEquivalentColorFromColorMAP(InpColorMap,InpMat,InpVal)
MaxVal = nanmax(InpMat(:));
MinVal = nanmin(InpMat(:));

Vector = linspace(MinVal,MaxVal,size(InpColorMap,1));
[~,Mindex] = nanmin(abs(Vector-InpVal));
EqColor = InpColorMap(Mindex,:);
EqCompColor = InpColorMap(end-Mindex+1,:);
end