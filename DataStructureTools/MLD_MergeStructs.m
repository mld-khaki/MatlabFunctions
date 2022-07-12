function OutStruct = MLD_MergeStructs(InStruct1,InStruct2)
OutStruct = InStruct2;
Fields = fieldnames(InStruct1);
for iCtr = 1:length(Fields)
    assert(isfield(OutStruct,Fields{iCtr}) == 0);
    OutStruct.(Fields{iCtr}) = InStruct1.(Fields{iCtr});
end
end