function [Output,Index] = MLD_nanminStruct(Input,StructField)
Output = inf;
Index = [];

for iCtr = 1:length(Input)
    if ~isnan(Input(iCtr).(StructField))
        if (Input(iCtr).(StructField) < Output)
            Output = Input(iCtr).(StructField);
            Index = iCtr;
        end
    end
end
if isinf(Output) && Output > 0
    Output = nan;
    Index = nan;
end
end
