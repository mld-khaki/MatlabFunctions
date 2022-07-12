function Out = MLD_SaveBigArray(InpArr,ArrayName,SavePath,CreateFolder)
Out = 0;
if ~exist('CreateFolder','var')
	CreateFolder = true;
end

[Savability,ChunkParts] = MLD_AUX_SavableInSplits(InpArr);
if Savability == false
	return
end

if CreateFolder == true
	FolderPath = [SavePath '\' ArrayName '.MldMatSav'];
else
	FolderPath = SavePath;
end
if ~exist(FolderPath,'dir')
	mkdir(FolderPath);
else
	error('Directory <%s> already exists!',FolderPath);
end

if size(InpArr,1) > size(InpArr,2)
	FlatterMatrix = 0;
else
	FlatterMatrix = 1;
end

TimeBeg = tic;
for iCtr=1:length(ChunkParts)
	FileName = sprintf('%s_Chunk%03u_D%u.mat',ArrayName,iCtr,FlatterMatrix);
	if FlatterMatrix
		Data = InpArr(:,ChunkParts{iCtr}(1):ChunkParts{iCtr}(2));
	else
		Data = InpArr(ChunkParts{iCtr}(1):ChunkParts{iCtr}(2),:);
	end
	save([FolderPath '\' FileName],'Data');
    fprintf('\nSaving variable %s, step %u of %u steps (%5.2f%%)...',ArrayName,iCtr,length(ChunkParts),iCtr*100/length(ChunkParts));
    fprintf('%s',ProjectedFinishCalculator(toc(TimeBeg),iCtr,length(ChunkParts),1));
    drawnow;
end
Out = 1;
end
