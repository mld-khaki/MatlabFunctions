function OutST = MLD_MergeStruct(InpST,AddStruct)
if isempty(InpST)
    OutST = AddStruct;
else
    NewInd = length(InpST)+1;
    AllFields = fieldnames(AddStruct);
    OutST = InpST;
    for fldCtr=1:length(AllFields)
        OutST(NewInd).(AllFields{fldCtr}) = AddStruct.(AllFields{fldCtr});
    end
end

end