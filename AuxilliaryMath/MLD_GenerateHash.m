function [OutHash, Index] = MLD_GenerateHash(Length,EnableCapitals,EnableLowers,EnableNumbers)

Possibles = [];

if EnableCapitals == true
    Possibles = [Possibles 'A':'Z'];
end
if EnableLowers == true
    Possibles = [Possibles 'a':'z'];
end
if EnableNumbers == true
    Possibles = [Possibles '0':'9'];
end

OutHash = Possibles(floor(length(Possibles)*rand(1,Length))+1);

Index = nansum(double(OutHash));

end
