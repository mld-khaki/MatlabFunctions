function OutVotes= MLD_Voter2(InputVotes)
OutVotes = nan(1,size(InputVotes,1));

MeanVotes = nanmean(InputVotes(:));
for iCtr=1:size(InputVotes,1)
    VoteOptions = unique(InputVotes(iCtr,:));
    VoteCount = zeros(size(VoteOptions));
    for vCtr=1:length(VoteOptions)
        VoteCount(vCtr) = nansum(InputVotes(iCtr,:)== VoteOptions(vCtr));
    end
    [CurVoteCount,VoteInd]=nanmax(VoteCount);
    VoteCount(VoteInd) = nan;
    [CurVoteCount2,VoteInd2] = nanmax(VoteCount);
    
    Ratio = CurVoteCount2/CurVoteCount;
    ZeroCount = nansum(VoteCount == 0);
    if Ratio > 0.6 && ZeroCount >= (length(VoteCount)/2)
        OutVotes(iCtr) = VoteOptions(VoteInd2);
    else
        OutVotes(iCtr) = VoteOptions(VoteInd);
    end
end

end