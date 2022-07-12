function Out = MLD_ReadIndexedData(Input,Index,ExpectedLength)
if iscell(Input)
    Out = Input{Index};
else
    if length(Input) == ExpectedLength
        Out = Input(Index);
    else
        Out = Input;
    end
end
end