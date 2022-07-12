function [res,Index] = FindStringInTableColumn(InpTable,ColumnNum,InputString)
Index = [];
res = 0;
for iCtr=1:size(InpTable,1)
   if strcmpi(InpTable{iCtr,ColumnNum},InputString) == 1
       Index(end+1) = iCtr;
       res = 1;
   end
end
end