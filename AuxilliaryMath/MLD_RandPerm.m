function [RandOut,RevRandOut] = MLD_RandPerm(VectCnt)
RandOut = randperm(VectCnt);
for iCtr=1:VectCnt
	RevRandOut(iCtr) = find(RandOut == iCtr);
end
end
