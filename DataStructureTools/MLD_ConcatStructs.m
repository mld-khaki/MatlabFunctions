function OutStruct = MLD_ConcatStructs(InpStruct,AddStruct)
OutStruct = InpStruct;

Fields = fieldnames(AddStruct);

for dCtr=1:length(AddStruct)
    CurInd = length(OutStruct)+1;
    for fldCtr=1:length(Fields)
        OutStruct(CurInd).(Fields{fldCtr}) = AddStruct(dCtr).(Fields{fldCtr});
    end
end
end