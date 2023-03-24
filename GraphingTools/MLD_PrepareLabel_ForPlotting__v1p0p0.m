function OutLabel = MLD_PrepareLabel_ForPlotting__v1p0p0(InpLabel)
OutLabel = InpLabel;
for qCtr=1:length(InpLabel)
    OutLabel(qCtr) = strrep(OutLabel(qCtr),"\","\\");
    OutLabel(qCtr) = strrep(OutLabel(qCtr),"_","\_");
end
end