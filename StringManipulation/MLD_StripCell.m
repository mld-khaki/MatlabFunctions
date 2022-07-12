function Out = MLD_StripCell(Input)
if isempty(Input)
    Out = [];
    return
else
    Out = Input;
    while(iscell(Out))
        Out = Out{1};
    end
end
end