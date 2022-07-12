function Status = MLD_SaveIfNotExists(InpFileNamePath,VariableName,Variable,Enable73BigFile) %#ok<INUSL>
eval([VariableName ' = Variable;']);
if ~exist(InpFileNamePath,'file')
    if Enable73BigFile == true
        save(InpFileNamePath,VariableName,'-v7.3');
    else
        save(InpFileNamePath,VariableName);
    end
else
    warning('File %s exists!',InpFileNamePath);
end

end