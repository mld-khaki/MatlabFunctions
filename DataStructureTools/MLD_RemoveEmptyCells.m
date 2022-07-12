function OutCellAr = MLD_RemoveEmptyCells(InpCellAr)
for iCtr=length(InpCellAr):-1:1
	if isempty(MLD_StripCell(InpCellAr{iCtr}))
		InpCellAr(iCtr) = [];
	end
end
OutCellAr = InpCellAr;

end
