function OutSig = MLD_Normalize(InpSig,Functions)
% example 
%     Sig1 = MLD_Normalize(Data.IED(qCtr).WAV_LP250Hz,{@(X) X - nanmean(X),@(X) X ./ nanstd(X)});
 
OutSig = InpSig;

for fCtr=1:length(Functions)
    OutSig = Functions{fCtr}(OutSig);
end

end
