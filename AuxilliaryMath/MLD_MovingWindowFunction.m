function [Out,OutInd] = MLD_MovingWindowFunction(InpStream,Function,Window,Overlap,Symmetric)
if ~exist('Symmetric','var')
	Symmetric = true;
end
WindowsStruct = nan(4,1);
wsCtr=0;
if Symmetric == true
	Beg = floor((Window-Overlap)/2);
	End = length(InpStream) - Beg + 1;
else
	Beg = 1;
	End = length(InpStream);
end

for wCtr=Beg:Window-Overlap:End
	if Symmetric == true
		WindHalf = floor(Window/2);
		Beg2 = wCtr - WindHalf+1;
		End2 = wCtr + WindHalf;
		Loc2 = wCtr;
	else
		Beg2 = wCtr;
		End2 = wCtr+Window-1;
		Loc2 = wCtr;
	end
	
	if End2 < length(InpStream) && Beg2 > 0
		wsCtr = wsCtr + 1;
		WindowsStruct(1,wsCtr) = Beg2;
		WindowsStruct(2,wsCtr) = End2;
		WindowsStruct(3,wsCtr) = End2;
		WindowsStruct(4,wsCtr) = wsCtr;
	end
end

Out = nan(1,length(WindowsStruct));
OutInd = Out;
for jCtr=1:length(WindowsStruct)
	Beg = WindowsStruct(1,jCtr);
	End = WindowsStruct(2,jCtr);
	PartSig = InpStream(Beg:End);
	Out(jCtr) = Function(PartSig);
	OutInd(jCtr) = WindowsStruct(3,jCtr);
end

end
