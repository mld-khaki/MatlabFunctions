function [Out,Index] = MLD_StructMax(InStruct,FocusField)
Array = zeros(1,length(InStruct));
for iCtr=1:length(InStruct)
    Array(iCtr) = InStruct(iCtr).(FocusField);
end
[Out,Index] = nanmax(Array);
end