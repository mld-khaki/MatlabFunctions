function Out = MLD_CumulativeProfileCalculator(Inp)
if isempty(Inp)
    Out = [];
    return;
end
Out = zeros(size(Inp));
Out(1) = Inp(1);

for iCtr=2:length(Inp)
    Out(iCtr) = nansum([Out(iCtr-1) Inp(iCtr)]);
end

end
