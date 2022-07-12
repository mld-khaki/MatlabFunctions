function Out = MLD_SaveBigData(InpSaveResults,InpVarName,SavePath)
Fields = fieldnames(InpSaveResults);
[Savability,~] = MLD_AUX_SavableInSplits(InpSaveResults);
if Savability == true
	MLD_SaveBigArray(InpSaveResults,InpVarName,SavePath,false)
else
	for iCtr=1:length(Fields)
		Data = InpSaveResults.(Fields{iCtr});
		
		StructFieldCount = 0;
		
		if isstruct(Data)
			StructFieldCount = length(fieldnames(Data));
		end
		FoldPath = [SavePath '\' InpVarName '.MldMatSav\'];
		wtmp = whos('Data');
		if wtmp.bytes < (1024^3)
			if ~exist(FoldPath,'dir')
				FoldPath
				mkdir(FoldPath);
			end
			save([FoldPath  '\' Fields{iCtr} '.NrmMatSav.mat'],'Data');
		else
			Status = 0;
			if StructFieldCount <= 1
				Status = MLD_SaveBigArray(Data,Fields{iCtr},[FoldPath '\' Fields{iCtr}],false);
			end
			
			if Status == 0 && StructFieldCount > 1
				NewSavePath = [FoldPath '\Re_entrantStruct_' Fields{iCtr}];
				MLD_SaveBigData(InpSaveResults.(Fields{iCtr}),Fields{iCtr},NewSavePath);
			end
		end
	end
end
end


