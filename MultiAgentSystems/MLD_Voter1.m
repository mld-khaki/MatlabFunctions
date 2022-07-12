function OutVotes= MLD_Voter(InputVotes)
OutVotes = nan(1,size(InputVotes,1));

for iCtr=1:size(InputVotes,1)
    VoteOptions = unique(InputVotes(iCtr,:));
    VoteCount = zeros(size(VoteOptions));
    for vCtr=1:length(VoteOptions)
        VoteCount(vCtr) = nansum(InputVotes(iCtr,:)== VoteOptions(vCtr));
    end
    [~,VoteInd]=nanmax(VoteCount);
    OutVotes(iCtr) = VoteOptions(VoteInd);
end

end