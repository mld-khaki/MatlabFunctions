function [res,Index] = FindStringInCellArray(CellArray,InputString)
Index = [];
res = 0;
for iCtr=1:length(CellArray)
   if strcmpi(CellArray{iCtr},InputString) == 1
       Index(end+1) = iCtr;
       res = 1;
   end
end
end