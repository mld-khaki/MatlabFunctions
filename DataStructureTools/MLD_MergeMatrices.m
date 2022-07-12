function Out = MLD_MergeMatrices(InMat1,InMat2,EqDimOut)
if ~exist('EqDimOut','var')
	EqDimOut = 1;
end

if (size(InMat1,1) == size(InMat2,1)) 
	Out = [InMat1 InMat2]';
elseif size(InMat1,2) == size(InMat2,1)
	Out = [InMat1' InMat2];
elseif size(InMat1,1) == size(InMat2,2)
	Out = [InMat1 InMat2'];
elseif (size(InMat1,2) == size(InMat2,2))
	Out = [InMat1' InMat2'];
else
	error('Two matrices do not match in any way!');
end

if EqDimOut == 1 
	Out = Out';
elseif EqDimOut == 2
else
	error('Unexpected dimension for merging matrices');
end

end
