function ByteStr = MLD_GetSizeString(Byte)
Prefixes = {' ','Kilo','Mega','Giga','Tera','Peta','Exa','Zetta','Yotta'};
ByteStr = 'Error!';
for iCtr=1:length(Prefixes)
	if Byte >= 1024^(iCtr-1) && Byte < 1024^iCtr
		ByteStr = sprintf('%6.2f %sB',Byte/(1024^(iCtr-1)),Prefixes{iCtr}(1));
		break
	end
end
