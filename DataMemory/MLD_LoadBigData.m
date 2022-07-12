function Out = MLD_LoadBigData(LoadPath,InpVarName,SkipVarCell)
% fprintf('\n%s , %s',LoadPath,InpVarName);
% drawnow;
if ~contains(InpVarName,'MldMatSav') && ~contains(InpVarName,'Re_entrantStruct')
	InpVarName = [InpVarName '.MldMatSav'];
end
if ~exist('SkipVarCell','var')
	SkipVarCell = {};
end

FullPath = [LoadPath '\' InpVarName '\'];
if ~exist(FullPath,'dir')
	error('The folder <%s> does not exist!',FullPath);
end

Folds = dir(FullPath);
for iCtr=1:length(Folds)
	if sum(strcmpi(Folds(iCtr).name,{'.','..'})) == 1
		continue;
	end
	
	
	if contains(Folds(iCtr).name,'NrmMatSav')
		VarName = strrep(Folds(iCtr).name,'.NrmMatSav.mat','');
		tmp = load([FullPath '\' Folds(iCtr).name]);
		Out.(VarName) = tmp.Data;
		continue;
	end
	
	ReEntName = 'Re_entrantStruct_';
	ReEntLen = length(ReEntName);
	HasReEnt = contains(Folds(iCtr).name,ReEntName);
	FindInd = strfind(Folds(iCtr).name,ReEntName);
	
	VarFolderExists = exist([FullPath '\' Folds(iCtr).name],'dir');
	
	if ~HasReEnt && (VarFolderExists > 0) 
		NewPathName = Folds(iCtr).name;
		VarName = strrep(NewPathName,'.MldMatSav','');
		FolderPath = MLD_CombineDirectoryWithFileFold(FullPath,'');
		Out.(VarName) = MLD_LoadBigArray(VarName,FolderPath,false);
		continue;
	end
	
	if HasReEnt == true
		VarName = Folds(iCtr).name(FindInd+ReEntLen:end);
%  		Out.(VarName) = MLD_LoadBigData(FullPath,Folds(iCtr).name,SkipVarCell);
		FolderPath = MLD_CombineDirectoryWithFileFold(FullPath,Folds(iCtr).name);
		if nansum(strcmpi(VarName,SkipVarCell)) >= 1
			Out.(VarName) = [];
        else
            try
			    Out.(VarName) = MLD_LoadBigData(FolderPath,VarName,SkipVarCell);
            catch
                Out.(VarName) = MLD_LoadBigArray(VarName,FolderPath,false,'V2');
            end
		end
		continue
	end

	InsideVarFolder = contains(InpVarName,ReEntName) && contains(Folds(iCtr).name,'Chunk');
	if InsideVarFolder == true
		VarName = strrep(InpVarName,ReEntName,'');
		if nansum(strcmpi(VarName,SkipVarCell)) >= 1
			Out = [];
		else
			Out = MLD_LoadBigArray(VarName,[LoadPath '\' InpVarName],false);
		end
		% we don't need the field as in Out.(Varname) because the re_entrant code has already created it.
		break;
	end
	
	
	error('Unknown file/folder type: <%s>',Folds(iCtr).name);
	
end
end


