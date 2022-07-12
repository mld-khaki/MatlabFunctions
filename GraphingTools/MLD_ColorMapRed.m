function Out = MLD_ColorMapCustom(Count,ColorRefBeg,ColorRefEnd)
if ~exist('Count','var')
    Count = 256;
elseif isempty(Count)
	Count = 256;
end

Out = zeros(Count,3);
Gradient = [linspace(ColorRefBeg(1),ColorRefEnd(1),Count) linspace(ColorRefBeg(2),ColorRefEnd(2),Count) linspace(ColorRefBeg(3),ColorRefEnd(3),Count)];
Out = Gradient
end
