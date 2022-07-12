function ParIndex = GenerateParallelIndexForWorkersV2(MaxParMachines,EntireListCount)
if MaxParMachines == 1
	ParIndex = {1:EntireListCount};
else
    ParIndex = {};
    ParIndex{MaxParMachines} = [];
    for iCtr=1:EntireListCount
        ParIndex{mod(iCtr,MaxParMachines)+1}(end+1) = iCtr;
    end
end
end