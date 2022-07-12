function [Output,Index] = MLD_nanmaxStruct(Input,StructField)
Output = -inf;
Index = [];
for iCtr = 1:length(Input)
    if ~isnan(eval(['Input(iCtr).' StructField]))
        if eval(['Input(iCtr).' StructField]) > Output
            Output = eval(['Input(iCtr).' StructField]);
            Index = iCtr;
        end
    end
end
if isinf(Output) && Output < 0
    Output = nan;
    Index = nan;
end
end
