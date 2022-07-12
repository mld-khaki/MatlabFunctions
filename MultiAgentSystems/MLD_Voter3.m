function [OutVotes, OutConfidence]= MLD_Voter3(InputVotes)
OutVotes = nan(1,size(InputVotes,1));

for iCtr=1:size(InputVotes,1)
    [VoteVal,VoteInd]=nanmax(InputVotes(iCtr,:));
    OutVotes(iCtr) = VoteInd;
    OutConfidence(iCtr) = VoteVal;
end

end