function [res,Index] = FindStringInStructArray(StructArray,StringField,InputString)
Index = [];
res = 0;
for iCtr=1:length(StructArray)
   if strcmpi(StructArray(iCtr).(StringField),InputString) == 1
       Index(end+1) = iCtr;
       res = 1;
   end
end
end