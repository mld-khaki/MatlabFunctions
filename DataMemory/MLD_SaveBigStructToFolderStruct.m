function Out = MLD_SaveBigStructToFolderStruct(InpVar,RootFolder,VarName)
Out = 0;
if isstruct(InpVar)
    Fields = fieldnames(InpVar);
    RootFolder = [RootFolder '\' VarName];
    mkdir(RootFolder);
else
    CurFolder = [RootFolder '\' ];
    fileName = [CurFolder '\' VarName '.mat'];
    fprintf('\nSaving file %s...',fileName);
    eval([VarName ' = InpVar;';])
    save(fileName,VarName);
    fprintf('done!');
    Out = 1;
    return
end

for iCtr=1:length(Fields)
    MLD_SaveBigStructToFolderStruct(InpVar.(Fields{iCtr}),[RootFolder], Fields{iCtr});
end

end